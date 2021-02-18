import 'package:dio/dio.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

import '../models/address.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/state.dart';

class AddressFormRepository {
  final String _baseUrl = 'https://api.megaleios.com/api/v1';
  final MegaDio _templateDio;

  AddressFormRepository(this._templateDio);

  Future<Address> loadFromCep(String cep) async {
    try {
      final response =
          await _templateDio.get('$_baseUrl/City/GetInfoFromZipCode/$cep');

      return Address.fromJson(response.data);
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<List<Country>> loadCountries() async {
    try {
      final response = await _templateDio.get('$_baseUrl/City/ListCountry');

      return (response.data as List).map((c) => Country.fromJson(c)).toList();
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<List<StateModel>> loadStates() async {
    try {
      final response = await _templateDio
          .get('$_baseUrl/City/ListState?countryId=${Country.brazil().id}');

      return (response.data as List)
          .map((c) => StateModel.fromJson(c))
          .toList();
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<List<City>> loadCities(String stateId) async {
    try {
      final response = await _templateDio.get('$_baseUrl/City/$stateId');

      return (response.data as List).map((c) => City.fromJson(c)).toList();
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }
}
