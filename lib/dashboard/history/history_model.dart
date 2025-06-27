import '/components/display_widget.dart';
import '/components/sidenav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'history_widget.dart' show HistoryWidget;
import 'package:flutter/material.dart';

class HistoryModel extends FlutterFlowModel<HistoryWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for sidenav component.
  late SidenavModel sidenavModel1;
  // Model for display component.
  late DisplayModel displayModel;
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
