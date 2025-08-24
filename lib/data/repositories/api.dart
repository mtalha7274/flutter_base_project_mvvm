import 'dart:async';
import '../../injection_container.dart';
import '../managers/local/custom_cache_manager.dart';
import '../managers/cache_policy.dart';
import '../../core/utils/helpers.dart';

/// Source of the data delivered to onData callback
/// - cache: came from local cache
/// - network: result of network fetch
enum ResponseOrigin { cache, network }

/// [ApiRepo] Mixin
///
/// Provides unified handling of:
/// - Local storage cache (TTL-aware)
/// - Retry + Rate limiting
/// - Auto-refreshing API requests
/// - Execution time logging
///
mixin ApiRepo {
  /// Local DB cache manager
  final CustomCacheManager _cacheManager = sl<CustomCacheManager>();

  /// Auto refresh controllers
  final Map<String, Timer> _autoRefreshTimers = {};

  /// How many times to retry API call
  int maxRetries = 2;

  /// Delay between retries
  Duration retryDelay = const Duration(seconds: 1);

  /// API calls per second allowed
  int? rateLimitPerSecond;

  /// Last API call timestamps (for rate-limiting)
  final Map<String, DateTime> _lastCallTimes = {};

  /// Makes a unified request that handles caching, optional serialization, timing, optional
  /// auto-refreshing, rate-limiting and graceful retry logic.
  ///
  /// This function provides:
  /// - Automatic cache lookup (with optional transformation).
  /// - Caching of API responses (memory + optional disk).
  /// - Optional API Auto-Refresh at a fixed interval.
  /// - Execution time logging (optional, in Debug mode).
  /// - Graceful fallback and error state wrapping.
  ///
  /// Parameters:
  ///
  /// [key]
  /// - *(Optional)* A string key used to read/write cache.
  /// - If omitted, the caller function's name will be used automatically as the key.
  ///
  /// [autoRefreshInterval]
  /// - *(Optional)* Defaults to `30 seconds`.
  /// - Time interval between consecutive auto-refresh API calls.
  /// - If not null, auto-refresh is considered enabled.
  ///
  /// [request]
  /// - *(Required)* The actual asynchronous API call to be executed.
  /// - Should return a raw `dynamic` value (e.g., JSON, Map, List, etc.).
  ///
  /// [ttl]
  /// - *(Optional)* Duration to keep cached value fresh on disk. If null, the entry does not auto-expire.
  ///
  /// [maxRetries]
  /// - *(Optional)* Number of retry attempts if the API call fails. Defaults to `2`.
  ///
  /// [retryDelay]
  /// - *(Optional)* Delay between retries. Increases linearly per attempt (i.e., 1s, 2s, 3s...).
  ///
  /// [rateLimitPerSecond]
  /// - *(Optional)* Max number of API calls allowed per second. Defaults to `null` (no limit).
  ///
  /// [cachePolicy]
  /// - *(Optional)* Cache behavior strategy:
  ///   - cacheOnly: return cached or throw if missing
  ///   - cacheFirst: return cached if present; otherwise fetch
  ///   - cacheThenNetwork: return cached immediately; then fetch on next call/auto-refresh
  ///   - networkFirst: try network; fallback to cached (fresh/stale) on failure
  ///   - networkOnly: always hit network
  /// - Default: `cacheThenNetwork`.
  ///
  /// [showLogs]
  /// - *(Optional)* When true, logs key, caller, cache time, API time, and relative speed.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// Calls [onData] with results from cache and/or network based on [cachePolicy].
  ///
  /// onData's second parameter indicates the origin (cache or network).
  ///
  /// NOTE: This method is intentionally fire-and-forget (void). Use callbacks to receive data.
  void onRequest<T>({
    String? key,
    Duration? autoRefreshInterval,
    required FutureOr<dynamic> Function() request,
    required void Function(T data, ResponseOrigin origin) onData,
    Duration? ttl,
    int? maxRetries,
    Duration? retryDelay,
    int? rateLimitPerSecond,
    CachePolicy cachePolicy = CachePolicy.cacheThenNetwork,
    bool showLogs = false,
  }) {
    final callerFunctionName = _getCallerFunctionName();
    key = key ?? callerFunctionName;

    if (showLogs) {
      printLog('🔑 key: $key, caller: $callerFunctionName');
    }

    // Fire-and-forget; rely on callbacks for results
    unawaited(
      _request<T>(
        key,
        autoRefreshInterval: autoRefreshInterval,
        request: request,
        onData: onData,
        ttl: ttl,
        maxRetriesOverride: maxRetries,
        retryDelayOverride: retryDelay,
        rateLimitPerSecondOverride: rateLimitPerSecond,
        cachePolicy: cachePolicy,
        showLogs: showLogs,
      ),
    );
  }

  /// Core request executor handling cache policies, retries, rate-limit and auto-refresh.
  Future<void> _request<T>(
    String key, {
    required FutureOr<dynamic> Function() request,
    required void Function(T data, ResponseOrigin origin) onData,
    Duration? autoRefreshInterval,
    Duration? ttl,
    int? maxRetriesOverride,
    Duration? retryDelayOverride,
    int? rateLimitPerSecondOverride,
    CachePolicy cachePolicy = CachePolicy.cacheThenNetwork,
    bool showLogs = false,
  }) async {
    // Internal helpers
    T? readCacheSync({bool allowExpired = false}) {
      final sw = Stopwatch()..start();
      final dynamic cachedRaw =
          _cacheManager.getCache(key: key, allowExpired: allowExpired);
      sw.stop();
      if (showLogs) {
        printLog(
            '🗄️  Cache read (${allowExpired ? 'allowExpired' : 'fresh'}) in ${sw.elapsedMs()}');
      }
      if (cachedRaw == null) return null;
      try {
        final T value = cachedRaw as T;
        return value;
      } catch (e) {
        if (showLogs) printLog('⚠️  Cache deserialize failed: $e');
        return null;
      }
    }

    Future<T?> fetchNetwork() async {
      // Rate limiting
      final int? rate = rateLimitPerSecondOverride ?? rateLimitPerSecond;
      if (rate.isEnabled) {
        final minIntervalMs = (1000 / rate!).floor();
        final last = _lastCallTimes[key];
        if (last != null) {
          final elapsed = DateTime.now().difference(last).inMilliseconds;
          final waitMs = minIntervalMs - elapsed;
          if (waitMs > 0) {
            if (showLogs) printLog('⏳ Rate limit: waiting ${waitMs}ms');
            await Future.delayed(waitMs.ms);
          }
        }
        _lastCallTimes[key] = DateTime.now();
      }

      final int retries = (maxRetriesOverride ?? maxRetries).clamp(0, 10);
      final Duration baseDelay = retryDelayOverride ?? retryDelay;

      int attempt = 0;
      while (true) {
        final sw = Stopwatch()..start();
        try {
          final dynamic raw = await request();
          sw.stop();
          if (showLogs) printLog('🌐 Network in ${sw.elapsedMs()}');
          // Cache raw response
          unawaited(_cacheManager.setCache(key: key, value: raw, ttl: ttl));
          // Cast for consumer
          final T value = raw as T;
          return value;
        } catch (e) {
          sw.stop();
          if (attempt >= retries) {
            if (showLogs) {
              printLog('❌ Network failed after ${attempt + 1} attempt(s): $e');
            }
            rethrow;
          }
          attempt += 1;
          final Duration nextDelay =
              Duration(milliseconds: baseDelay.inMilliseconds * attempt);
          if (showLogs) {
            printLog('🔁 Retry #$attempt in ${nextDelay.inMilliseconds}ms');
          }
          await Future.delayed(nextDelay);
        }
      }
    }

    // Execute per policy
    try {
      if (showLogs) printLog('📦 Policy: ${cachePolicy.name}');

      switch (cachePolicy) {
        case CachePolicy.cacheOnly:
          final T? cached = readCacheSync(allowExpired: false);
          if (cached != null) {
            onData(cached, ResponseOrigin.cache);
          }
          break;

        case CachePolicy.networkOnly:
          final T value = (await fetchNetwork()) as T;
          onData(value, ResponseOrigin.network);
          break;

        case CachePolicy.cacheFirst:
          final T? cached = readCacheSync(allowExpired: false);
          if (cached != null) {
            onData(cached, ResponseOrigin.cache);
          } else {
            final T value = (await fetchNetwork()) as T;
            onData(value, ResponseOrigin.network);
          }
          break;

        case CachePolicy.networkFirst:
          try {
            final T value = (await fetchNetwork()) as T;
            onData(value, ResponseOrigin.network);
          } catch (_) {
            final T? cached = readCacheSync(allowExpired: true);
            if (cached != null) onData(cached, ResponseOrigin.cache);
          }
          break;

        case CachePolicy.cacheThenNetwork:
          final T? cached = readCacheSync(allowExpired: false);
          if (cached != null) {
            // Synchronous delivery for immediate UI update
            onData(cached, ResponseOrigin.cache);
          }
          // Fire and also provide network update when ready
          unawaited(
            fetchNetwork().then((value) {
              if (value != null) onData(value, ResponseOrigin.network);
            }).catchError((_) {}),
          );
          break;
      }

      // Setup auto-refresh if requested
      if (autoRefreshInterval.isEnabled) {
        // Cancel any previous timer for this key
        _autoRefreshTimers[key]?.cancel();
        _autoRefreshTimers[key] =
            Timer.periodic(autoRefreshInterval!, (_) async {
          if (showLogs) printLog('🔄 Auto-refresh tick for $key');
          try {
            final T? value = await fetchNetwork();
            if (value != null) onData(value, ResponseOrigin.network);
          } catch (e) {
            if (showLogs) printLog('⚠️  Auto-refresh failed: $e');
          }
        });
      }
    } catch (e) {
      // Intentionally swallow errors here since no error callback is defined.
      if (showLogs) printLog('⚠️  Request error: $e');
    }
  }

  String _getCallerFunctionName() {
    final traceLines = StackTrace.current.toString().split('\n');
    final callerLine = traceLines.length > 2 ? traceLines[2] : '';
    final match = RegExp(r'#\d+\s+([^\s]+)').firstMatch(callerLine);
    return match?.group(1) ?? 'unknown_function';
  }
}

// Memory cache removed; using disk cache only via CustomCacheManager.

void unawaited(Future<void> future) {}

extension _NumExt on num {
  Duration get ms => Duration(milliseconds: toInt());
}

extension _StopwatchLog on Stopwatch {
  String elapsedMs() => '${elapsedMilliseconds}ms';
}

extension _NullableDuration on Duration? {
  bool get isEnabled => this != null;
}

extension _NullableInt on int? {
  bool get isEnabled => this != null && this! > 0;
}

extension _CachePolicyName on CachePolicy {
  String get name => toString().split('.').last;
}
