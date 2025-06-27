import 'dart:convert';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class WeatherCall {
  static Future<ApiCallResponse> call({
    double? long,
    double? lat,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Weather',
      apiUrl:
          'https://api.openweathermap.org/data/3.0/onecall?lat=${lat}&lon=${long}&exclude=hourly,daily&appid=83730a0942931ab17140519084b9e3d1',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'lat': lat,
        'long': long,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static double? temp(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.temp''',
      ));
  static int? sunset(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.current.sunset''',
      ));
  static int? pressure(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.current.pressure''',
      ));
  static double? windspeed(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.current.wind_speed''',
      ));
  static int? humidity(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.current.humidity''',
      ));
  static String? desc(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.current.weather[:].description''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
