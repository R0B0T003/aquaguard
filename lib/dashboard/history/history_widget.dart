import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/display_widget.dart';
import '/components/sidenav_widget.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'history_model.dart';
export 'history_model.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  static String routeName = 'history';
  static String routePath = '/history';

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  late HistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HistoryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (currentUserDocument?.device == null) {
        context.pushNamed(OnboardingWidget.routeName);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        drawer: Drawer(
          elevation: 16.0,
          child: Visibility(
            visible: responsiveVisibility(
              context: context,
              tabletLandscape: false,
              desktop: false,
            ),
            child: wrapWithModel(
              model: _model.sidenavModel2,
              updateCallback: () => safeSetState(() {}),
              child: SidenavWidget(),
            ),
          ),
        ),
        appBar: MediaQuery.sizeOf(context).width <= 991.0
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: true,
                title: Text(
                  FFAppConstants.APPNAME,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).info,
                        fontSize: 32.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
                actions: [],
                centerTitle: false,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                wrapWithModel(
                  model: _model.sidenavModel1,
                  updateCallback: () => safeSetState(() {}),
                  child: SidenavWidget(),
                ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: AuthUserStreamWidget(
                    builder: (context) => StreamBuilder<List<HistoryRecord>>(
                      stream: queryHistoryRecord(
                        parent: currentUserDocument?.device,
                        queryBuilder: (historyRecord) =>
                            historyRecord.orderBy('timestamp'),
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          );
                        }
                        List<HistoryRecord> maxWidthHistoryRecordList =
                            snapshot.data!;

                        return Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxWidth: 1170.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  wrapWithModel(
                                    model: _model.displayModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: DisplayWidget(),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 24.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Soil moisture and air humidity history',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 12.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 400.0,
                                            child: FlutterFlowLineChart(
                                              data: [
                                                FFLineChartData(
                                                  xData:
                                                      maxWidthHistoryRecordList
                                                          .map((d) =>
                                                              d.timestamp)
                                                          .toList(),
                                                  yData:
                                                      maxWidthHistoryRecordList
                                                          .map(
                                                              (d) => d.moisture)
                                                          .toList(),
                                                  settings: LineChartBarData(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary,
                                                    barWidth: 2.0,
                                                    isCurved: true,
                                                    preventCurveOverShooting:
                                                        true,
                                                  ),
                                                ),
                                                FFLineChartData(
                                                  xData:
                                                      maxWidthHistoryRecordList
                                                          .map((d) =>
                                                              d.timestamp)
                                                          .toList(),
                                                  yData:
                                                      maxWidthHistoryRecordList
                                                          .map(
                                                              (d) => d.humidity)
                                                          .toList(),
                                                  settings: LineChartBarData(
                                                    color: Color(0xFFCD9E1C),
                                                    barWidth: 2.0,
                                                    isCurved: true,
                                                    preventCurveOverShooting:
                                                        true,
                                                    dotData:
                                                        FlDotData(show: false),
                                                  ),
                                                )
                                              ],
                                              chartStylingInfo:
                                                  ChartStylingInfo(
                                                enableTooltip: true,
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                showGrid: true,
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                borderWidth: 1.0,
                                              ),
                                              axisBounds: AxisBounds(),
                                              xAxisLabelInfo: AxisLabelInfo(
                                                reservedSize: 32.0,
                                              ),
                                              yAxisLabelInfo: AxisLabelInfo(
                                                showLabels: true,
                                                labelTextStyle: TextStyle(),
                                                labelInterval: 10.0,
                                                reservedSize: 40.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 24.0)),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2.0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Temperature trend',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 400.0,
                                          child: FlutterFlowLineChart(
                                            data: [
                                              FFLineChartData(
                                                xData: maxWidthHistoryRecordList
                                                    .map((d) => d.temperature)
                                                    .toList(),
                                                yData: maxWidthHistoryRecordList
                                                    .map((d) => d.temperature)
                                                    .toList(),
                                                settings: LineChartBarData(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  barWidth: 2.0,
                                                ),
                                              )
                                            ],
                                            chartStylingInfo: ChartStylingInfo(
                                              enableTooltip: true,
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              showGrid: true,
                                              borderColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              borderWidth: 1.0,
                                            ),
                                            axisBounds: AxisBounds(),
                                            xAxisLabelInfo: AxisLabelInfo(
                                              reservedSize: 32.0,
                                            ),
                                            yAxisLabelInfo: AxisLabelInfo(
                                              showLabels: true,
                                              labelInterval: 10.0,
                                              reservedSize: 40.0,
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 12.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
