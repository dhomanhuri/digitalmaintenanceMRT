library mrt.globals;

import 'package:mrt/database/department.dart';

bool isLoggedIn = false;
String workorder_notemp = '';
String titletemp = '';
String locationtemp = '';
String areatemp = '';
String delaytemp = '';
String reportdepartmenttemp = '';
String receivedepartmenttemp = '';
String wonumberexecutetemp = '';
String report_datetemp = '';
String failure_datetemp = '';
String failure_timetemp = '';
String systemtemp = '';
String system_subtemp = '';
String equipmenttemp = '';
String equipment_idtemp = '';
String trainsettemp = '';
String failure_descriptiontemp = '';
String report_actiontemp = '';
String woexecuteidtemp = '1';
String failureexecuteidtemp = '1';
double datafailureopentemp = 0;
double datafailureclosetemp = 0;
double datafailureprogresstemp = 0;
double datafailureneedrevisiontemp = 0;
double datatotal = datafailureclosetemp +
    datafailureopentemp +
    datafailureprogresstemp +
    datafailureneedrevisiontemp;
double percentfailureprogress = (datafailureprogresstemp / datatotal) * 100;
double percentfailureopen = 0;
double percentfailureclose = 0;
double percentfailureneedrevision = 0;
String materialnametemp = '';
String materialqtytemp = '';
String materialidtemp = '';
String unitnametemp = '';
String unitqtytemp = '';
String unitidtemp = '';
String checksheetequipmentidtemp = '';
String checksheetperiodtemp = '';
String checksheetitemtemp = '';
String checksheetrefrencetemp = '';
String checksheettipetemp = '';
String checksheethasiltemp = '';
List<dynamic> closewopdf = [];
String revisionidtemp = '';
String workorderidtemp = '';
String workordernotemp = '';
String workorderdescriptiontemp = '';
String workorderdepartmenttemp = '';
String workorderdepartmentidtemp = '';
String workorderperiodtemp = '';
String workorderstartdatetemp = '';
String manualViews = '';
