import '../objects.dart' show Base, Simple;
import '../http/http.dart' show Session;
import 'enrollments.dart' as enrollments_api;

/// https://canvas.instructure.com/doc/api/courses.html#Term
class Term extends Simple {
  Term({Map<String, dynamic>? attributes}) {
    this.attributes = attributes ?? {};
  }
  Object? get id => getattr('id');
  Object? get name => getattr('name');
  Object? get startAt => getattr('start_at');
  Object? get endAt => getattr('end_at');
}

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
  Object? get term => getattr(
        'term',
        constructor: (attributes) => Term(attributes: attributes),
      );

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

  Object? get overriddenCourseVisibility =>
      getattr('overridden_course_visibility');

  /// "sections": Section enrollment information to include with each Course. Returns an
  /// array of hashes containing the section ID (id), section name (name), start and end
  /// dates (start_at, end_at), as well as the enrollment type (enrollment_role, e.g.
  /// 'StudentEnrollment').
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get sections => getattr('sections');

  /// "passback_status": Include the grade passback_status
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get passbackStatus => getattr('passback_status');

  /// include[]=current_grading_period_scores
  Object? get hasGradingPeriods => getattr('has_grading_periods');

  /// include[]=current_grading_period_scores
  Object? get multipleGradingPeriodsEnabled =>
      getattr('multiple_grading_periods_enabled');

  /// include[]=current_grading_period_scores
  Object? get hasWeightedGradingPeriods =>
      getattr('has_weighted_grading_periods');

  /// "account": Optional information to include with each Course. When account is given,
  /// the account json for each course is returned.
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get account => getattr('account');

  /// "favorites": Optional information to include with each Course. Indicates if the user has
  /// marked the course as a favorite course.
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get isFavorite => getattr('is_favorite');

  /// "teachers": Teacher information to include with each Course. Returns an array of
  /// hashes containing the UserDisplay information for each teacher in the course.
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get teachers => getattr('teachers');

  /// "course_image": Optional course image data for when there is a course image and the
  /// course image feature flag has been enabled
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get imageDownloadUrl => getattr('image_download_url');

  /// "concluded": Optional information to include with each Course. Indicates whether the
  /// course has been concluded, taking course and term dates into account.
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get concluded => getattr('concluded');

  /// "tabs": Optional information to include with each Course. Will include the list of tabs
  /// configured for each course. See the List available tabs API for more information.
  ///
  /// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
  Object? get tabs => getattr('tabs');
}

/// A Canvas user, e.g. a student, teacher, administrator, observer, etc.
///
/// https://canvas.instructure.com/doc/api/users.html#User
class User extends Base {
  User({Map<String, dynamic>? attributes, Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id', 'name'];

  /// The ID of the user.
  Object? get id => getattr('id');

  /// The name of the user.
  Object? get name => getattr('name');

  /// The name of the user that is should be used for sorting groups of users, such
  /// as in the gradebook.
  Object? get sortableName => getattr('sortable_name');

  /// A short name the user has selected, for use in conversations or other less
  /// formal places through the site.
  Object? get shortName => getattr('short_name');

  /// The SIS ID associated with the user.  This field is only included if the user
  /// came from a SIS import and has permissions to view SIS information.
  Object? get sisUserId => getattr('sis_user_id');

  /// The id of the SIS import.  This field is only included if the user came from
  /// a SIS import and has permissions to manage SIS information.
  Object? get sisImportId => getattr('sis_import_id');

  /// The integration_id associated with the user.  This field is only included if
  /// the user came from a SIS import and has permissions to view SIS information.
  Object? get integrationId => getattr('integration_id');

  /// The unique login id for the user.  This is what the user uses to log in to
  /// Canvas.
  Object? get loginId => getattr('login_id');

  /// If avatars are enabled, this field will be included and contain a url to
  /// retrieve the user's avatar.
  Object? get avatarUrl => getattr('avatar_url');

  /// Optional: This field can be requested with certain API calls, and will return
  /// a list of the users active enrollments. See the List enrollments API for more
  /// details about the format of these records.
  Object? get enrollments => getattr(
        'enrollments',
        constructor: (attributes) => enrollments_api.Enrollment(
            attributes: attributes, session: session, baseUrl: baseUrl),
        isList: true,
      );

  /// Optional: This field can be requested with certain API calls, and will return
  /// the users primary email address.
  Object? get email => getattr('email');

  /// Optional: This field can be requested with certain API calls, and will return
  /// the users locale in RFC 5646 format.
  Object? get locale => getattr('locale');

  /// Optional: This field is only returned in certain API calls, and will return a
  /// timestamp representing the last time the user logged in to canvas.
  Object? get lastLogin => getattr('last_login');

  /// Optional: This field is only returned in certain API calls, and will return
  /// the IANA time zone name of the user's preferred timezone.
  Object? get timeZone => getattr('time_zone');

  /// Optional: The user's bio.
  Object? get bio => getattr('bio');
}
