import '../http/http.dart' show Session;
import '../objects.dart' show Interface;
import 'courses.dart' as courses;
import 'dashboards.dart' as dashboards;
import 'paginations.dart' show Pagination;
import 'tabs.dart' as tabs;
import 'users.dart' as users;

// https://github.com/instructure/canvas-lms/blob/master/config/routes.rb

class Api with Interface {
  var courses = CoursesInterface();
  var dashboards = DashboardsInterface();
  var tabs = TabsInterface();
  var users = UsersInterface();

  Api({Session? session, Uri? baseUrl}) {
    this.subInterfaces.addAll([
      courses,
      dashboards,
      tabs,
      users,
    ]);
    this.session = session;
    this.baseUrl = baseUrl;
  }
}

class CoursesInterface with Interface {
  CoursesInterface({Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Pagination<courses.Course> getCourses({
    Object? enrollmentType,
    Object? enrollmentRole,
    Object? enrollmentRoleId,
    Object? enrollmentState,
    Object? excludeBlueprintCourses,
    Object? include,
    Object? state,
    Object? page,
    int? perPage,
    Object? params,
  }) {
    return courses.getCourses(
      session!,
      baseUrl!,
      enrollmentType: enrollmentType,
      enrollmentRole: enrollmentRole,
      enrollmentRoleId: enrollmentRoleId,
      enrollmentState: enrollmentState,
      excludeBlueprintCourses: excludeBlueprintCourses,
      include: include,
      state: state,
      perPage: perPage,
      page: page,
      params: params,
    );
  }

  Future<courses.Course> getCourse({
    required Object id,
    Object? accountId,
    Object? include,
    int? teacherLimit,
    Object? params,
  }) {
    return courses.getCourse(
      session!,
      baseUrl!,
      id: id,
      accountId: accountId,
      include: include,
      teacherLimit: teacherLimit,
      params: params,
    );
  }

  Pagination<tabs.Tab> getAvailableTabs({
    required Object id,
    Object? include,
    Object? page,
    int? perPage,
    Object? params,
  }) {
    return tabs.getAvailableTabs(
      session!,
      baseUrl!,
      context: 'courses',
      contextId: id,
      include: include,
      page: page,
      perPage: perPage,
      params: params,
    );
  }
}

class DashboardsInterface with Interface {
  DashboardsInterface({Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Future<List<dashboards.DashboardCard>> getDashboardCards({Object? params}) {
    return dashboards.getDashboardCards(session!, baseUrl!, params: params);
  }
}

class TabsInterface with Interface {
  TabsInterface({Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Pagination<tabs.Tab> getAvailableTabs({
    required String context,
    required Object contextId,
    Object? include,
    Object? page,
    int? perPage,
    Object? params,
  }) {
    return tabs.getAvailableTabs(
      session!,
      baseUrl!,
      context: context,
      contextId: contextId,
      include: include,
      page: page,
      perPage: perPage,
      params: params,
    );
  }
}

class UsersInterface with Interface {
  UsersInterface({Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Future getCustomColors({required Object id, Object? params}) {
    return users.getCustomColors(session!, baseUrl!, id: id, params: params);
  }
}
