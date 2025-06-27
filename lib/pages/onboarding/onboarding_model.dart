import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'onboarding_widget.dart' show OnboardingWidget;
import 'package:flutter/material.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
  ///  Local state fields for this page.

  LatLng? location;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for device widget.
  FocusNode? deviceFocusNode;
  TextEditingController? deviceTextController;
  String? Function(BuildContext, String?)? deviceTextControllerValidator;
  String? _deviceTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter Device ID is required';
    }

    if (val.length < 3) {
      return 'Requires at least 3 characters.';
    }

    return null;
  }

  // State field(s) for crop widget.
  String? cropValue;
  FormFieldController<String>? cropValueController;
  // State field(s) for farm_area widget.
  FocusNode? farmAreaFocusNode;
  TextEditingController? farmAreaTextController;
  String? Function(BuildContext, String?)? farmAreaTextControllerValidator;
  String? _farmAreaTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Farm Area (m^2) is required';
    }

    if (val.length < 1) {
      return 'Requires at least 1 characters.';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  IotDataRecord? device;

  @override
  void initState(BuildContext context) {
    deviceTextControllerValidator = _deviceTextControllerValidator;
    farmAreaTextControllerValidator = _farmAreaTextControllerValidator;
  }

  @override
  void dispose() {
    deviceFocusNode?.dispose();
    deviceTextController?.dispose();

    farmAreaFocusNode?.dispose();
    farmAreaTextController?.dispose();
  }
}
