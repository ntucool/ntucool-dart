import '../http/http.dart' as http;
import '../objects.dart' as objects;
import 'courses.dart' as courses;
import 'dashboards.dart' as dashboards;
import 'discussion_topics.dart' as discussion_topics;
import 'files.dart' as files;
import 'js_env.dart' as js_env;
import 'paginations.dart' as paginations;
import 'roles.dart' as roles;
import 'tabs.dart' as tabs;
import 'users.dart' as users;

// https://github.com/instructure/canvas-lms/blob/master/config/routes.rb

class Api with objects.Interface {
  var courses = CoursesInterface();
  var dashboards = DashboardsInterface();
  var discussionTopics = DiscussionTopicsInterface();
  var files = FilesInterface();
  var roles = RolesInterface();
  var tabs = TabsInterface();
  var users = UsersInterface();
  var jsEnv = JsEnvInterface();

  Api({http.Session? session, Uri? baseUrl}) {
    this.subInterfaces.addAll([
      courses,
      dashboards,
      discussionTopics,
      files,
      roles,
      tabs,
      users,
      jsEnv,
    ]);
    this.session = session;
    this.baseUrl = baseUrl;
  }
}

class CoursesInterface with objects.Interface {
  CoursesInterface({http.Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  paginations.Pagination<courses.Course> listCourses({
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
    required Object? id,
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

  paginations.Pagination<users.User> listUsersInCourse({
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

  paginations.Pagination<tabs.Tab> getAvailableTabs({
    required Object? id,
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

class DashboardsInterface with objects.Interface {
  DashboardsInterface({http.Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Future<List<dashboards.DashboardCard>> getDashboardCards({Object? params}) {
    return dashboards.getDashboardCards(session!, baseUrl!, params: params);
  }
}

class DiscussionTopicsInterface with objects.Interface {
  DiscussionTopicsInterface({http.Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  paginations.Pagination<discussion_topics.DiscussionTopic>
      listDiscussionTopics({
    required String context,
    required Object? contextId,
    Object? include,
    Object? orderBy,
    Object? scope,
    Object? onlyAnnouncements,
    Object? filterBy,
    Object? searchTerm,
    Object? excludeContextModuleLockedTopics,
    Object? page,
    int? perPage,
    Object? params,
  }) {
    return discussion_topics.listDiscussionTopics(
      session!,
      baseUrl!,
      context: context,
      contextId: contextId,
      include: include,
      orderBy: orderBy,
      scope: scope,
      onlyAnnouncements: onlyAnnouncements,
      filterBy: filterBy,
      searchTerm: searchTerm,
      excludeContextModuleLockedTopics: excludeContextModuleLockedTopics,
      page: page,
      perPage: perPage,
      params: params,
    );
  }
}

class RolesInterface with objects.Interface {
  RolesInterface({http.Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  paginations.Pagination<roles.Role> listRoles({
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

class FilesInterface with objects.Interface {
  FilesInterface({http.Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  paginations.Pagination<files.File> listFiles({
    required String context,
    required Object? contextId,
    Object? contentTypes,
    Object? excludeContentTypes,
    Object? searchTerm,
    Object? include,
    Object? only,
    Object? sort,
    Object? order,
    Object? page,
    int? perPage,
    Object? params,
  }) {
    return files.listFiles(
      session!,
      baseUrl!,
      context: context,
      contextId: contextId,
      contentTypes: contentTypes,
      excludeContentTypes: excludeContentTypes,
      searchTerm: searchTerm,
      include: include,
      only: only,
      sort: sort,
      order: order,
      page: page,
      perPage: perPage,
      params: params,
    );
  }
}

class TabsInterface with objects.Interface {
  TabsInterface({http.Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  paginations.Pagination<tabs.Tab> getAvailableTabs({
    required String context,
    required Object? contextId,
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

class UsersInterface with objects.Interface {
  UsersInterface({http.Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Future getCustomColors({required Object id, Object? params}) {
    return users.getCustomColors(session!, baseUrl!, id: id, params: params);
  }
}

class JsEnvInterface with objects.Interface {
  JsEnvInterface({http.Session? session, Uri? baseUrl}) {
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
