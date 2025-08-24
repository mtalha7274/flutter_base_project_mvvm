enum CachePolicy {
  /// Only return cached data. Do not hit network. Throw if missing.
  cacheOnly,

  /// Only hit network. Ignore cache. Do not fallback.
  networkOnly,

  /// Return cache if present and valid; otherwise fetch from network.
  cacheFirst,

  /// Try network first; if it fails, return cache if available.
  networkFirst,

  /// Immediately provide cached data via onCached, then fetch network and update cache.
  cacheThenNetwork,
}
