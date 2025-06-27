import '/components/display_widget.dart';
import '/components/sidenav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'settings_widget.dart' show SettingsWidget;
import 'package:flutter/material.dart';

class SettingsModel extends FlutterFlowModel<SettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for sidenav component.
  late SidenavModel sidenavModel1;
  // Model for display component.
  late DisplayModel displayModel;
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;
  // State field(s) for Switch widget.
  bool? switchValue3;
  // State field(s) for Switch widget.
  bool? switchValue4;
  // Model for sidenav component.
  late SidenavModel sidenavModel2;

  @override
  void initState(BuildContext context) {
    sidenavModel1 = createModel(context, () => SidenavModel());
    displayModel = createModel(context, () => DisplayModel());
    sidenavModel2 = createModel(context, () => SidenavModel());
  }

  @override
  void dispose() {
    sidenavModel1.dispose();
    displayModel.dispose();
    sidenavModel2.dispose();
  }
}
