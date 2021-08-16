import '../http/http.dart' show Session;
import '../objects.dart' show Interface;
import 'courses.dart' as courses;
import 'dashboards.dart' as dashboards;
import 'js_env.dart' as js_env;
import 'paginations.dart' show Pagination;
import 'roles.dart' as roles;
import 'tabs.dart' as tabs;
import 'users.dart' as users;

// https://github.com/instructure/canvas-lms/blob/master/config/routes.rb

class Api with Interface {
  var courses = CoursesInterface();
  var dashboards = DashboardsInterface();
  var roles = RolesInterface();
  var tabs = TabsInterface();
  var users = UsersInterface();
  var jsEnv = JsEnvInterface();

  Api({Session? session, Uri? baseUrl}) {
    this.subInterfaces.addAll([
      courses,
      dashboards,
      roles,
      tabs,
      users,
      jsEnv,
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

  Pagination<courses.Course> listCourses({
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
    return courses.listCourses(
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
    Object? teacherLimit,
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

  Pagination<users.User> listUsersInCourse({
    required Object? courseId,
    String endpoint = 'users',
    Object? searchTerm,
    Object? sort,
    Object? enrollmentType,
    Object? enrollmentRole,
    Object? enrollmentRoleId,
    Object? include,
    Object? userId,
    Object? userIds,
    Object? enrollmentState,
    Object? page,
    int? perPage,
    Object? params,
  }) {
    return courses.listUsersInCourse(
      session!,
      baseUrl!,
      courseId: courseId,
      endpoint: endpoint,
      searchTerm: searchTerm,
      sort: sort,
      enrollmentType: enrollmentType,
      enrollmentRole: enrollmentRole,
      enrollmentRoleId: enrollmentRoleId,
      include: include,
      userId: userId,
      userIds: userIds,
      enrollmentState: enrollmentState,
      page: page,
      perPage: perPage,
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

class RolesInterface with Interface {
  RolesInterface({Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Pagination<roles.Role> listRoles({
    required Object? accountId,
    Object? state,
    Object? showInherited,
    Object? page,
    int? perPage,
    Object? params,
  }) {
    return roles.listRoles(
      session!,
      baseUrl!,
      accountId: accountId,
      state: state,
      showInherited: showInherited,
      page: page,
      perPage: perPage,
      params: params,
    );
  }

  getRole({
    required Object? accountId,
    required Object? id,
    Object? role,
    Object? params,
  }) {
    return roles.getRole(
      session!,
      baseUrl!,
      accountId: accountId,
      id: id,
      role: role,
      params: params,
    );
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

class JsEnvInterface with Interface {
  JsEnvInterface({Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Future<js_env.JsEnv?> maybeRoster({
    required Object? courseId,
  }) {
    return js_env.maybeRoster(
      session!,
      baseUrl!,
      courseId: courseId,
    );
  }
}
