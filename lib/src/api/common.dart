import 'package:ntucool/src/api/paginations.dart';

import '../objects.dart' show Base;
import '../http/http.dart' show Session;

/// https://canvas.instructure.com/doc/api/courses.html#Course
class Course extends Base {
  Course({Map<String, dynamic>? attributes, Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id', 'name'];

  /// the unique identifier for the course
  Object? get id => getattr('id');

  /// the SIS identifier for the course, if defined. This field is only included if
  /// the user has permission to view SIS information.
  Object? get sisCourseId => getattr('sis_course_id');

  /// the UUID of the course
  Object? get uuid => getattr('uuid');

  /// the integration identifier for the course, if defined. This field is only
  /// included if the user has permission to view SIS information.
  Object? get integrationId => getattr('integration_id');

  /// the unique identifier for the SIS import. This field is only included if the
  /// user has permission to manage SIS information.
  Object? get sisImportId => getattr('sis_import_id');

  /// the full name of the course
  Object? get name => getattr('name');

  /// the course code
  Object? get courseCode => getattr('course_code');

  /// the current state of the course one of 'unpublished', 'available',
  /// 'completed', or 'deleted'
  Object? get workflowState => getattr('workflow_state');

  /// the account associated with the course
  Object? get accountId => getattr('account_id');

  /// the root account associated with the course
  Object? get rootAccountId => getattr('root_account_id');

  /// the enrollment term associated with the course
  Object? get enrollmentTermId => getattr('enrollment_term_id');

  /// A list of grading periods associated with the course
  Object? get gradingPeriods => getattr('grading_periods');

  /// the grading standard associated with the course
  Object? get gradingStandardId => getattr('grading_standard_id');

  /// the grade_passback_setting set on the course
  Object? get gradePassbackSetting => getattr('grade_passback_setting');

  /// the date the course was created.
  Object? get createdAt => getattr('created_at');

  /// the start date for the course, if applicable
  Object? get startAt => getattr('start_at');

  /// the end date for the course, if applicable
  Object? get endAt => getattr('end_at');

  /// the course-set locale, if applicable
  Object? get locale => getattr('locale');

  /// A list of enrollments linking the current user to the course. for student
  /// enrollments, grading information may be included if include[]=total_scores
  Object? get enrollments => getattr('enrollments');

  /// optional: the total number of active and invited students in the course
  Object? get totalStudents => getattr('total_students');

  /// course calendar
  Object? get calendar => getattr('calendar');

  /// the type of page that users will see when they first visit the course -
  /// 'feed': Recent Activity Dashboard - 'wiki': Wiki Front Page - 'modules':
  /// Course Modules/Sections Page - 'assignments': Course Assignments List -
  /// 'syllabus': Course Syllabus Page other types may be added in the future
  Object? get defaultView => getattr('default_view');

  /// optional: user-generated HTML for the course syllabus
  Object? get syllabusBody => getattr('syllabus_body');

  /// optional: the number of submissions needing grading returned only if the
  /// current user has grading rights and include[]=needs_grading_count
  Object? get needsGradingCount => getattr('needs_grading_count');

  /// optional: the enrollment term object for the course returned only if
  /// include[]=term
  Object? get term => getattr('term');

  /// optional: information on progress through the course returned only if
  /// include[]=course_progress
  Object? get courseProgress => getattr('course_progress');

  /// weight final grade based on assignment group percentages
  Object? get applyAssignmentGroupWeights =>
      getattr('apply_assignment_group_weights');

  /// optional: the permissions the user has for the course. returned only for a
  /// single course and include[]=permissions
  Object? get permissions => getattr('permissions');
  Object? get isPublic => getattr('is_public');
  Object? get isPublicToAuthUsers => getattr('is_public_to_auth_users');
  Object? get publicSyllabus => getattr('public_syllabus');
  Object? get publicSyllabusToAuth => getattr('public_syllabus_to_auth');

  /// optional: the public description of the course
  Object? get publicDescription => getattr('public_description');
  Object? get storageQuotaMb => getattr('storage_quota_mb');
  Object? get storageQuotaUsedMb => getattr('storage_quota_used_mb');
  Object? get hideFinalGrades => getattr('hide_final_grades');
  Object? get license => getattr('license');
  Object? get allowStudentAssignmentEdits =>
      getattr('allow_student_assignment_edits');
  Object? get allowWikiComments => getattr('allow_wiki_comments');
  Object? get allowStudentForumAttachments =>
      getattr('allow_student_forum_attachments');
  Object? get openEnrollment => getattr('open_enrollment');
  Object? get selfEnrollment => getattr('self_enrollment');
  Object? get restrictEnrollmentsToCourseDates =>
      getattr('restrict_enrollments_to_course_dates');
  Object? get courseFormat => getattr('course_format');

  /// optional: this will be true if this user is currently prevented from viewing
  /// the course because of date restriction settings
  Object? get accessRestrictedByDate => getattr('access_restricted_by_date');

  /// The course's IANA time zone name.
  Object? get timeZone => getattr('time_zone');

  /// optional: whether the course is set as a Blueprint Course (blueprint fields
  /// require the Blueprint Courses feature)
  Object? get blueprint => getattr('blueprint');

  /// optional: Set of restrictions applied to all locked course objects
  Object? get blueprintRestrictions => getattr('blueprint_restrictions');

  /// optional: Sets of restrictions differentiated by object type applied to
  /// locked course objects
  Object? get blueprintRestrictionsByObjectType =>
      getattr('blueprint_restrictions_by_object_type');

  /// optional: whether the course is set as a template (requires the Course
  /// Templates feature)
  Object? get template => getattr('template');
}

/// List your courses
///
/// `GET /api/v1/courses`
///
/// Returns the paginated list of active courses for the current user.
///
/// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
Pagination<Course> listYourCourses(
  Session session,
  Uri baseUrl, {
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
  var method = 'GET';
  var url = '/api/v1/courses';
  var paramsList = [];
  return Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: (value) =>
        Course(attributes: value, session: session, baseUrl: baseUrl),
  );
}