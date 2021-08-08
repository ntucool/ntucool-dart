import '../http/http.dart' show Session;
import '../objects.dart' show Interface;
import 'courses.dart' as courses;
import 'dashboards.dart' as dashboards;
import 'paginations.dart' show Pagination;
import 'users.dart' as users;

// https://github.com/instructure/canvas-lms/blob/master/config/routes.rb

class Api with Interface {
  late CoursesInterface courses;
  late DashboardsInterface dashboards;
  late UsersInterface users;

  Api({Session? session, Uri? baseUrl}) {
    courses = CoursesInterface();
    dashboards = DashboardsInterface();
    users = UsersInterface();
    this.subInterfaces.addAll([courses, dashboards, users]);
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
    Object? enrollmentRoleId,
    Object? enrollmentState,
    Object? excludeBlueprintCourses,
    Object? include,
    Object? state,
    int? perPage,
    Object? page,
    Object? params,
  }) {
    return courses.getCourses(
      session!,
      baseUrl!,
      enrollmentType: enrollmentType,
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

class UsersInterface with Interface {
  UsersInterface({Session? session, Uri? baseUrl}) {
    this.session = session;
    this.baseUrl = baseUrl;
  }

  Future getCustomColors({Object? id, Object? params}) {
    return users.getCustomColors(session!, baseUrl!, id: id, params: params);
  }
}
