import '/backend/api_requests/api_calls.dart';
import '/components/display_widget.dart';
import '/components/progress_widget.dart';
import '/components/sidenav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for sidenav component.
  late SidenavModel sidenavModel1;
  // Model for display component.
  late DisplayModel displayModel;
  // Model for soil_moisture.
  late ProgressModel soilMoistureModel;
  // Model for air_humidity.
  late ProgressModel airHumidityModel;
  // Model for temperature.
  late ProgressModel temperatureModel;
  // Model for sidenav component.
  late SidenavModel sidenavModel2;

  /// Query cache managers for this widget.

  final _weatherManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> weather({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _weatherManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearWeatherCache() => _weatherManager.clear();
  void clearWeatherCacheKey(String? uniqueKey) =>
      _weatherManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {
    sidenavModel1 = createModel(context, () => SidenavModel());
    displayModel = createModel(context, () => DisplayModel());
    soilMoistureModel = createModel(context, () => ProgressModel());
    airHumidityModel = createModel(context, () => ProgressModel());
    temperatureModel = createModel(context, () => ProgressModel());
    sidenavModel2 = createModel(context, () => SidenavModel());
  }

  @override
  void dispose() {
    sidenavModel1.dispose();
    displayModel.dispose();
    soilMoistureModel.dispose();
    airHumidityModel.dispose();
    temperatureModel.dispose();
    sidenavModel2.dispose();

    /// Dispose query cache managers for this widget.

    clearWeatherCache();
  }
}
