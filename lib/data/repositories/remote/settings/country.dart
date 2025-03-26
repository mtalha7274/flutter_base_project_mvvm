import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/error_handler.dart';
import '../../../managers/remote/api_manager.dart';

class CountryRepo {
  final ApiManager _apiManager;
  CountryRepo(this._apiManager);

  Future<DataState<String>> getCountry() async {
    final dataState = await ErrorHandler.onNetworkRequest<String>(
      fetch: () async {
        final response = await _apiManager.get('/json',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'});
        final country = response['country'];
        return country;
      },
    );
    return dataState;
  }
}
