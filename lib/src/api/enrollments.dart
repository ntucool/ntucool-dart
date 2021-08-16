import '../http/http.dart' as http;
import '../objects.dart' as objects;

class Enrollment extends objects.Base {
  Enrollment(
      {Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id'];

  /// The ID of the enrollment.
  Object? get id => getattr('id');

  /// The unique id of the course.
  Object? get courseId => getattr('course_id');

  /// The SIS Course ID in which the enrollment is associated. Only displayed if
  /// present. This field is only included if the user has permission to view SIS
  /// information.
  Object? get sisCourseId => getattr('sis_course_id');

  /// The Course Integration ID in which the enrollment is associated. This field
  /// is only included if the user has permission to view SIS information.
  Object? get courseIntegrationId => getattr('course_integration_id');

  /// The unique id of the user's section.
  Object? get courseSectionId => getattr('course_section_id');

  /// The Section Integration ID in which the enrollment is associated. This field
  /// is only included if the user has permission to view SIS information.
  Object? get sectionIntegrationId => getattr('section_integration_id');

  /// The SIS Account ID in which the enrollment is associated. Only displayed if
  /// present. This field is only included if the user has permission to view SIS
  /// information.
  Object? get sisAccountId => getattr('sis_account_id');

  /// The SIS Section ID in which the enrollment is associated. Only displayed if
  /// present. This field is only included if the user has permission to view SIS
  /// information.
  Object? get sisSectionId => getattr('sis_section_id');

  /// The SIS User ID in which the enrollment is associated. Only displayed if
  /// present. This field is only included if the user has permission to view SIS
  /// information.
  Object? get sisUserId => getattr('sis_user_id');

  /// The state of the user's enrollment in the course.
  Object? get enrollmentState => getattr('enrollment_state');

  /// User can only access his or her own course section.
  Object? get limitPrivilegesToCourseSection =>
      getattr('limit_privileges_to_course_section');

  /// The unique identifier for the SIS import. This field is only included if the
  /// user has permission to manage SIS information.
  Object? get sisImportId => getattr('sis_import_id');

  /// The unique id of the user's account.
  Object? get rootAccountId => getattr('root_account_id');

  /// The enrollment type. One of 'StudentEnrollment', 'TeacherEnrollment',
  /// 'TaEnrollment', 'DesignerEnrollment', 'ObserverEnrollment'.
  Object? get type => getattr('type');

  /// The unique id of the user.
  Object? get userId => getattr('user_id');

  /// The unique id of the associated user. Will be null unless type is
  /// ObserverEnrollment.
  Object? get associatedUserId => getattr('associated_user_id');

  /// The enrollment role, for course-level permissions. This field will match
  /// `type` if the enrollment role has not been customized.
  Object? get role => getattr('role');

  /// The id of the enrollment role.
  Object? get roleId => getattr('role_id');

  /// The created time of the enrollment, in ISO8601 format.
  Object? get createdAt => getattr('created_at');

  /// The updated time of the enrollment, in ISO8601 format.
  Object? get updatedAt => getattr('updated_at');

  /// The start time of the enrollment, in ISO8601 format.
  Object? get startAt => getattr('start_at');

  /// The end time of the enrollment, in ISO8601 format.
  Object? get endAt => getattr('end_at');

  /// The last activity time of the user for the enrollment, in ISO8601 format.
  Object? get lastActivityAt => getattr('last_activity_at');

  /// The last attended date of the user for the enrollment in a course, in ISO8601
  /// format.
  Object? get lastAttendedAt => getattr('last_attended_at');

  /// The total activity time of the user for the enrollment, in seconds.
  Object? get totalActivityTime => getattr('total_activity_time');

  /// The URL to the Canvas web UI page for this course enrollment.
  Object? get htmlUrl => getattr('html_url');

  /// The URL to the Canvas web UI page containing the grades associated with this
  /// enrollment.
  Object? get grades => getattr('grades');

  /// A description of the user.
  Object? get user => getattr('user');

  /// The user's override grade for the course.
  Object? get overrideGrade => getattr('override_grade');

  /// The user's override score for the course.
  Object? get overrideScore => getattr('override_score');

  /// The user's current grade in the class including muted/unposted assignments.
  /// Only included if user has permissions to view this grade, typically teachers,
  /// TAs, and admins.
  Object? get unpostedCurrentGrade => getattr('unposted_current_grade');

  /// The user's final grade for the class including muted/unposted assignments.
  /// Only included if user has permissions to view this grade, typically teachers,
  /// TAs, and admins..
  Object? get unpostedFinalGrade => getattr('unposted_final_grade');

  /// The user's current score in the class including muted/unposted assignments.
  /// Only included if user has permissions to view this score, typically teachers,
  /// TAs, and admins..
  Object? get unpostedCurrentScore => getattr('unposted_current_score');

  /// The user's final score for the class including muted/unposted assignments.
  /// Only included if user has permissions to view this score, typically teachers,
  /// TAs, and admins..
  Object? get unpostedFinalScore => getattr('unposted_final_score');

  /// optional: Indicates whether the course the enrollment belongs to has grading
  /// periods set up. (applies only to student enrollments, and only available in
  /// course endpoints)
  Object? get hasGradingPeriods => getattr('has_grading_periods');

  /// optional: Indicates whether the course the enrollment belongs to has the
  /// Display Totals for 'All Grading Periods' feature enabled. (applies only to
  /// student enrollments, and only available in course endpoints)
  Object? get totalsForAllGradingPeriodsOption =>
      getattr('totals_for_all_grading_periods_option');

  /// optional: The name of the currently active grading period, if one exists. If
  /// the course the enrollment belongs to does not have grading periods, or if no
  /// currently active grading period exists, the value will be null. (applies only
  /// to student enrollments, and only available in course endpoints)
  Object? get currentGradingPeriodTitle =>
      getattr('current_grading_period_title');

  /// optional: The id of the currently active grading period, if one exists. If
  /// the course the enrollment belongs to does not have grading periods, or if no
  /// currently active grading period exists, the value will be null. (applies only
  /// to student enrollments, and only available in course endpoints)
  Object? get currentGradingPeriodId => getattr('current_grading_period_id');

  /// The user's override grade for the current grading period.
  Object? get currentPeriodOverrideGrade =>
      getattr('current_period_override_grade');

  /// The user's override score for the current grading period.
  Object? get currentPeriodOverrideScore =>
      getattr('current_period_override_score');

  /// optional: The student's score in the course for the current grading period,
  /// including muted/unposted assignments. Only included if user has permission to
  /// view this score, typically teachers, TAs, and admins. If the course the
  /// enrollment belongs to does not have grading periods, or if no currently
  /// active grading period exists, the value will be null. (applies only to
  /// student enrollments, and only available in course endpoints)
  Object? get currentPeriodUnpostedCurrentScore =>
      getattr('current_period_unposted_current_score');

  /// optional: The student's score in the course for the current grading period,
  /// including muted/unposted assignments and including ungraded assignments with
  /// a score of 0. Only included if user has permission to view this score,
  /// typically teachers, TAs, and admins. If the course the enrollment belongs to
  /// does not have grading periods, or if no currently active grading period
  /// exists, the value will be null. (applies only to student enrollments, and
  /// only available in course endpoints)
  Object? get currentPeriodUnpostedFinalScore =>
      getattr('current_period_unposted_final_score');

  /// optional: The letter grade equivalent of
  /// current_period_unposted_current_score, if available. Only included if user
  /// has permission to view this grade, typically teachers, TAs, and admins. If
  /// the course the enrollment belongs to does not have grading periods, or if no
  /// currently active grading period exists, the value will be null. (applies only
  /// to student enrollments, and only available in course endpoints)
  Object? get currentPeriodUnpostedCurrentGrade =>
      getattr('current_period_unposted_current_grade');

  /// optional: The letter grade equivalent of current_period_unposted_final_score,
  /// if available. Only included if user has permission to view this grade,
  /// typically teachers, TAs, and admins. If the course the enrollment belongs to
  /// does not have grading periods, or if no currently active grading period
  /// exists, the value will be null. (applies only to student enrollments, and
  /// only available in course endpoints)
  Object? get currentPeriodUnpostedFinalGrade =>
      getattr('current_period_unposted_final_grade');
}
