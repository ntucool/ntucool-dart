import '../http/http.dart' as http;
import '../objects.dart' as objects;
import '../utils.dart' as utils;
import 'paginations.dart' as paginations;

/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.replies
class Reply extends objects.Base {
  Reply({Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id', 'user_id'];

  /// The unique identifier for the reply.
  Object? get id => getattr('id');

  /// The unique identifier for the author of the reply.
  Object? get userId => getattr('user_id');

  /// The unique user id of the person to last edit the entry, if different than user_id.
  Object? get editorId => getattr('editor_id');

  /// The name of the author of the reply.
  Object? get userName => getattr('user_name');

  /// The content of the reply.
  Object? get message => getattr('message');

  /// The read state of the entry, “read” or “unread”.
  Object? get readState => getattr('read_state');

  /// Whether the read_state was forced (was set manually)
  Object? get forcedReadState => getattr('forced_read_state');

  /// The creation time of the reply, in ISO8601 format.
  Object? get createdAt => getattr('created_at');
  Object? get parentId => getattr('parent_id');
  Object? get updatedAt => getattr('updated_at');
  Object? get ratingCount => getattr('rating_count');
  Object? get ratingSum => getattr('rating_sum');
  Object? get user => getattr('user');
  Object? get attachment => getattr('attachment');
  Object? get attachments => getattr('attachments');
}

/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.entries
class Entry extends objects.Base {
  Entry({Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id', 'user_id'];

  /// The unique identifier for the entry.
  Object? get id => getattr('id');

  /// The unique identifier for the author of the entry.
  Object? get userId => getattr('user_id');

  /// The unique user id of the person to last edit the entry, if different than user_id.
  Object? get editorId => getattr('editor_id');

  /// The name of the author of the entry.
  Object? get userName => getattr('user_name');

  /// The content of the entry.
  Object? get message => getattr('message');

  /// The read state of the entry, “read” or “unread”.
  Object? get readState => getattr('read_state');

  /// Whether the read_state was forced (was set manually)
  Object? get forcedReadState => getattr('forced_read_state');

  /// The creation time of the entry, in ISO8601 format.
  Object? get createdAt => getattr('created_at');

  /// The updated time of the entry, in ISO8601 format.
  Object? get updatedAt => getattr('updated_at');

  /// JSON representation of the attachment for the entry, if any. Present only if there is an attachment.
  Object? get attachment => getattr('attachment');

  /// Deprecated. Same as attachment, but returned as a one-element array. Present only if there is an attachment.
  Object? get attachments => getattr('attachments');

  /// The 10 most recent replies for the entry, newest first. Present only if there is at least one reply.
  Object? get recentReplies => getattr('recent_replies');

  /// True if there are more than 10 replies for the entry (i.e., not all were included in this response). Present only if there is at least one reply.
  Object? get hasMoreReplies => getattr('has_more_replies');
  Object? get parentId => getattr('parent_id');
  Object? get ratingCount => getattr('rating_count');
  Object? get ratingSum => getattr('rating_sum');
  Object? get user => getattr('user');
}

/// A discussion topic
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#DiscussionTopic
class DiscussionTopic extends objects.Base {
  DiscussionTopic(
      {Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id', 'title'];

  /// The ID of this topic.
  Object? get id => getattr('id');

  /// The topic title.
  Object? get title => getattr('title');

  /// The HTML content of the message body.
  Object? get message => getattr('message');

  /// The URL to the discussion topic in canvas.
  Object? get htmlUrl => getattr('html_url');

  /// The datetime the topic was posted. If it is null it hasn't been posted yet.
  /// (see delayed_post_at)
  Object? get postedAt => getattr('posted_at');

  /// The datetime for when the last reply was in the topic.
  Object? get lastReplyAt => getattr('last_reply_at');

  /// If true then a user may not respond to other replies until that user has made
  /// an initial reply. Defaults to false.
  Object? get requireInitialPost => getattr('require_initial_post');

  /// Whether or not posts in this topic are visible to the user.
  Object? get userCanSeePosts => getattr('user_can_see_posts');

  /// The count of entries in the topic.
  Object? get discussionSubentryCount => getattr('discussion_subentry_count');

  /// The read_state of the topic for the current user, 'read' or 'unread'.
  Object? get readState => getattr('read_state');

  /// The count of unread entries of this topic for the current user.
  Object? get unreadCount => getattr('unread_count');

  /// Whether or not the current user is subscribed to this topic.
  Object? get subscribed => getattr('subscribed');

  /// (Optional) Why the user cannot subscribe to this topic. Only one reason will
  /// be returned even if multiple apply. Can be one of: 'initial_post_required':
  /// The user must post a reply first; 'not_in_group_set': The user is not in the
  /// group set for this graded group discussion; 'not_in_group': The user is not
  /// in this topic's group; 'topic_is_announcement': This topic is an announcement
  Object? get subscriptionHold => getattr('subscription_hold');

  /// The unique identifier of the assignment if the topic is for grading,
  /// otherwise null.
  Object? get assignmentId => getattr('assignment_id');

  /// The datetime to publish the topic (if not right away).
  Object? get delayedPostAt => getattr('delayed_post_at');

  /// Whether this discussion topic is published (true) or draft state (false)
  Object? get published => getattr('published');

  /// The datetime to lock the topic (if ever).
  Object? get lockAt => getattr('lock_at');

  /// Whether or not the discussion is 'closed for comments'.
  Object? get locked => getattr('locked');

  /// Whether or not the discussion has been 'pinned' by an instructor
  Object? get pinned => getattr('pinned');

  /// Whether or not this is locked for the user.
  Object? get lockedForUser => getattr('locked_for_user');

  /// (Optional) Information for the user about the lock. Present when
  /// locked_for_user is true.
  Object? get lockInfo => getattr('lock_info');

  /// (Optional) An explanation of why this is locked for the user. Present when
  /// locked_for_user is true.
  Object? get lockExplanation => getattr('lock_explanation');

  /// The username of the topic creator.
  Object? get userName => getattr('user_name');

  /// DEPRECATED An array of topic_ids for the group discussions the user is a part
  /// of.
  Object? get topicChildren => getattr('topic_children');

  /// An array of group discussions the user is a part of. Fields include: id,
  /// group_id
  Object? get groupTopicChildren => getattr('group_topic_children');

  /// If the topic is for grading and a group assignment this will point to the
  /// original topic in the course.
  Object? get rootTopicId => getattr('root_topic_id');

  /// If the topic is a podcast topic this is the feed url for the current user.
  Object? get podcastUrl => getattr('podcast_url');

  /// The type of discussion. Values are 'side_comment', for discussions that only
  /// allow one level of nested comments, and 'threaded' for fully threaded
  /// discussions.
  Object? get discussionType => getattr('discussion_type');

  /// The unique identifier of the group category if the topic is a group
  /// discussion, otherwise null.
  Object? get groupCategoryId => getattr('group_category_id');

  /// Array of file attachments.
  Object? get attachments => getattr('attachments');

  /// The current user's permissions on this topic.
  Object? get permissions => getattr('permissions');

  /// Whether or not users can rate entries in this topic.
  Object? get allowRating => getattr('allow_rating');

  /// Whether or not grade permissions are required to rate entries.
  Object? get onlyGradersCanRate => getattr('only_graders_can_rate');

  /// Whether or not entries should be sorted by rating.
  Object? get sortByRating => getattr('sort_by_rating');

  /// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics.index
  Object? get userCount => getattr('user_count');

  /// which course the announcement belongs to
  ///
  /// https://canvas.instructure.com/doc/api/announcements.html#method.announcements_api.index
  Object? get contextCode => getattr('context_code');
  Object? get createdAt => getattr('created_at');
  Object? get position => getattr('position');
  Object? get podcastHasStudentPosts => getattr('podcast_has_student_posts');
  Object? get isSectionSpecific => getattr('is_section_specific');
  Object? get canUnpublish => getattr('can_unpublish');
  Object? get canLock => getattr('can_lock');
  Object? get commentsDisabled => getattr('comments_disabled');
  Object? get author => getattr('author');
  Object? get url => getattr('url');
  Object? get canGroup => getattr('can_group');
  Object? get todoDate => getattr('todo_date');
}

/// List discussion topics
///
/// `GET /api/v1/courses/:course_id/discussion_topics`
///
/// `GET /api/v1/groups/:group_id/discussion_topics`
///
/// Returns the paginated list of discussion topics for this course or group.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics.index
paginations.Pagination<DiscussionTopic> listDiscussionTopics(
  http.Session session,
  Uri baseUrl, {
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
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/discussion_topics';
  var p = [
    ['include', include],
    ['order_by', orderBy],
    ['scope', scope],
    ['only_announcements', onlyAnnouncements],
    ['filter_by', filterBy],
    ['search_term', searchTerm],
    ['exclude_context_module_locked_topics', excludeContextModuleLockedTopics],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor = (value) =>
      DiscussionTopic(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Create a new discussion topic
///
/// `POST /api/v1/courses/:course_id/discussion_topics`
///
/// `POST /api/v1/groups/:group_id/discussion_topics`
///
/// Create an new discussion topic for the course or group.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics.create
Future createDiscussionTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  Object? title,
  Object? message,
  Object? discussionType,
  Object? published,
  Object? delayedPostAt,
  Object? allowRating,
  Object? lockAt,
  Object? podcastEnabled,
  Object? podcastHasStudentPosts,
  Object? requireInitialPost,
  Object? assignment,
  Object? isAnnouncement,
  Object? pinned,
  Object? positionAfter,
  Object? groupCategoryId,
  Object? onlyGradersCanRate,
  Object? sortByRating,
  Object? attachment,
  Object? specificSections,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var url = '/api/v1/$context/$contextId/discussion_topics';
  var p = [
    ['title', title],
    ['message', message],
    ['discussion_type', discussionType],
    ['published', published],
    ['delayed_post_at', delayedPostAt],
    ['allow_rating', allowRating],
    ['lock_at', lockAt],
    ['podcast_enabled', podcastEnabled],
    ['podcast_has_student_posts', podcastHasStudentPosts],
    ['require_initial_post', requireInitialPost],
    ['assignment', assignment],
    ['is_announcement', isAnnouncement],
    ['pinned', pinned],
    ['position_after', positionAfter],
    ['group_category_id', groupCategoryId],
    ['only_graders_can_rate', onlyGradersCanRate],
    ['sort_by_rating', sortByRating],
    ['attachment', attachment],
    ['specific_sections', specificSections],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Update a topic
///
/// `PUT /api/v1/courses/:course_id/discussion_topics/:topic_id`
///
/// `PUT /api/v1/groups/:group_id/discussion_topics/:topic_id`
///
/// Update an existing discussion topic for the course or group.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics.update
Future updateTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? title,
  Object? message,
  Object? discussionType,
  Object? published,
  Object? delayedPostAt,
  Object? lockAt,
  Object? podcastEnabled,
  Object? podcastHasStudentPosts,
  Object? requireInitialPost,
  Object? assignment,
  Object? isAnnouncement,
  Object? pinned,
  Object? positionAfter,
  Object? groupCategoryId,
  Object? allowRating,
  Object? onlyGradersCanRate,
  Object? sortByRating,
  Object? specificSections,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId';
  var p = [
    ['title', title],
    ['message', message],
    ['discussion_type', discussionType],
    ['published', published],
    ['delayed_post_at', delayedPostAt],
    ['lock_at', lockAt],
    ['podcast_enabled', podcastEnabled],
    ['podcast_has_student_posts', podcastHasStudentPosts],
    ['require_initial_post', requireInitialPost],
    ['assignment', assignment],
    ['is_announcement', isAnnouncement],
    ['pinned', pinned],
    ['position_after', positionAfter],
    ['group_category_id', groupCategoryId],
    ['allow_rating', allowRating],
    ['only_graders_can_rate', onlyGradersCanRate],
    ['sort_by_rating', sortByRating],
    ['specific_sections', specificSections],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Delete a topic
///
/// `DELETE /api/v1/courses/:course_id/discussion_topics/:topic_id`
///
/// `DELETE /api/v1/groups/:group_id/discussion_topics/:topic_id`
///
/// Deletes the discussion topic. This will also delete the assignment, if it's an assignment discussion.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics.destroy
Future deleteTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'DELETE';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Reorder pinned topics
///
/// `POST /api/v1/courses/:course_id/discussion_topics/reorder`
///
/// `POST /api/v1/groups/:group_id/discussion_topics/reorder`
///
/// Puts the pinned discussion topics in the specified order. All pinned topics should be included.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics.reorder
Future reorderPinnedTopics(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  Object? order,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var url = '/api/v1/$context/$contextId/discussion_topics/reorder';
  var p = [
    ['order', order],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Update an entry
///
/// `PUT /api/v1/courses/:course_id/discussion_topics/:topic_id/entries/:id`
///
/// `PUT /api/v1/groups/:group_id/discussion_topics/:topic_id/entries/:id`
///
/// Update an existing discussion entry.
///
/// The entry must have been created by the current user, or the current user must have admin rights to the discussion. If the edit is not allowed, a 401 will be returned.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_entries.update
Future updateEntry(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  required Object? id,
  Object? message,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var url =
      '/api/v1/$context/$contextId/discussion_topics/$topicId/entries/$id';
  var p = [
    ['message', message],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Delete an entry
///
/// `DELETE /api/v1/courses/:course_id/discussion_topics/:topic_id/entries/:id`
///
/// `DELETE /api/v1/groups/:group_id/discussion_topics/:topic_id/entries/:id`
///
/// Delete a discussion entry.
///
/// The entry must have been created by the current user, or the current user must have admin rights to the discussion. If the delete is not allowed, a 401 will be returned.
///
/// The discussion will be marked deleted, and the user_id and message will be cleared out.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_entries.destroy
Future deleteEntry(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  required Object? id,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'DELETE';
  var url =
      '/api/v1/$context/$contextId/discussion_topics/$topicId/entries/$id';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Get a single topic
///
/// `GET /api/v1/courses/:course_id/discussion_topics/:topic_id`
///
/// `GET /api/v1/groups/:group_id/discussion_topics/:topic_id`
///
/// Returns data on an individual discussion topic. See the List action for the response formatting.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.show
Future<DiscussionTopic> getTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? include,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId';
  var p = [
    ['include', include],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return DiscussionTopic(attributes: data, session: session, baseUrl: baseUrl);
}

/// Get the full topic
///
/// `GET /api/v1/courses/:course_id/discussion_topics/:topic_id/view`
///
/// `GET /api/v1/groups/:group_id/discussion_topics/:topic_id/view`
///
/// Return a cached structure of the discussion topic, containing all entries, their authors, and their message bodies.
///
/// May require (depending on the topic) that the user has posted in the topic. If it is required, and the user has not posted, will respond with a 403 Forbidden status and the body 'require_initial_post'.
///
/// In some rare situations, this cached structure may not be available yet. In that case, the server will respond with a 503 error, and the caller should try again soon.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.view
Future getFullTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? includeNewEntries,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/view';
  var p = [
    ['include_new_entries', includeNewEntries],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Post an entry
///
/// `POST /api/v1/courses/:course_id/discussion_topics/:topic_id/entries`
///
/// `POST /api/v1/groups/:group_id/discussion_topics/:topic_id/entries`
///
/// Create a new entry in a discussion topic. Returns a json representation of the created entry (see documentation for 'entries' method) on success.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.add_entry
Future postEntry(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? message,
  Object? attachment,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/entries';
  var p = [
    ['message', message],
    ['attachment', attachment],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// Duplicate discussion topic
///
/// `POST /api/v1/courses/:course_id/discussion_topics/:topic_id/duplicate`
///
/// `POST /api/v1/groups/:group_id/discussion_topics/:topic_id/duplicate`
///
/// Duplicate a discussion topic according to context (Course/Group)
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.duplicate
Future<DiscussionTopic> duplicateDiscussionTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/duplicate';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return DiscussionTopic(attributes: data, session: session, baseUrl: baseUrl);
}

/// List topic entries
///
/// `GET /api/v1/courses/:course_id/discussion_topics/:topic_id/entries`
///
/// `GET /api/v1/groups/:group_id/discussion_topics/:topic_id/entries`
///
/// Retrieve the (paginated) top-level entries in a discussion topic.
///
/// May require (depending on the topic) that the user has posted in the topic. If it is required, and the user has not posted, will respond with a 403 Forbidden status and the body 'require_initial_post'.
///
/// Will include the 10 most recent replies, if any, for each entry returned.
///
/// If the topic is a root topic with children corresponding to groups of a group assignment, entries from those subtopics for which the user belongs to the corresponding group will be returned.
///
/// Ordering of returned entries is newest-first by posting timestamp (reply activity is ignored).
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.entries
paginations.Pagination<Entry> listTopicEntries(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/entries';
  var p = [
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => Entry(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Post a reply
///
/// `POST /api/v1/courses/:course_id/discussion_topics/:topic_id/entries/:entry_id/replies`
///
/// `POST /api/v1/groups/:group_id/discussion_topics/:topic_id/entries/:entry_id/replies`
///
/// Add a reply to an entry in a discussion topic. Returns a json representation of the created reply (see documentation for 'replies' method) on success.
///
/// May require (depending on the topic) that the user has posted in the topic. If it is required, and the user has not posted, will respond with a 403 Forbidden status and the body 'require_initial_post'.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.add_reply
Future postReply(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  required Object? entryId,
  Object? message,
  Object? attachment,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var url =
      '/api/v1/$context/$contextId/discussion_topics/$topicId/entries/$entryId/replies';
  var p = [
    ['message', message],
    ['attachment', attachment],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}

/// List entry replies
///
/// `GET /api/v1/courses/:course_id/discussion_topics/:topic_id/entries/:entry_id/replies`
///
/// `GET /api/v1/groups/:group_id/discussion_topics/:topic_id/entries/:entry_id/replies`
///
/// Retrieve the (paginated) replies to a top-level entry in a discussion topic.
///
/// May require (depending on the topic) that the user has posted in the topic. If it is required, and the user has not posted, will respond with a 403 Forbidden status and the body 'require_initial_post'.
///
/// Ordering of returned entries is newest-first by creation timestamp.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.replies
paginations.Pagination<Reply> listEntryReplies(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  required Object? entryId,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url =
      '/api/v1/$context/$contextId/discussion_topics/$topicId/entries/$entryId/replies';
  var p = [
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => Reply(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// List entries
///
/// `GET /api/v1/courses/:course_id/discussion_topics/:topic_id/entry_list`
///
/// `GET /api/v1/groups/:group_id/discussion_topics/:topic_id/entry_list`
///
/// Retrieve a paginated list of discussion entries, given a list of ids.
///
/// May require (depending on the topic) that the user has posted in the topic. If it is required, and the user has not posted, will respond with a 403 Forbidden status and the body 'require_initial_post'.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.entry_list
paginations.Pagination<Entry> listEntries(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? ids,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/entry_list';
  var p = [
    ['ids', ids],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => Entry(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Mark topic as read
///
/// `PUT /api/v1/courses/:course_id/discussion_topics/:topic_id/read`
///
/// `PUT /api/v1/groups/:group_id/discussion_topics/:topic_id/read`
///
/// Mark the initial text of the discussion topic as read.
///
/// No request fields are necessary.
///
/// On success, the response will be 204 No Content with an empty body.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.mark_topic_read
Future<bool> markTopicAsRead(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/read';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Mark topic as unread
///
/// `DELETE /api/v1/courses/:course_id/discussion_topics/:topic_id/read`
///
/// `DELETE /api/v1/groups/:group_id/discussion_topics/:topic_id/read`
///
/// Mark the initial text of the discussion topic as unread.
///
/// No request fields are necessary.
///
/// On success, the response will be 204 No Content with an empty body.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.mark_topic_unread
Future<bool> markTopicAsUnread(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'DELETE';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/read';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Mark all entries as read
///
/// `PUT /api/v1/courses/:course_id/discussion_topics/:topic_id/read_all`
///
/// `PUT /api/v1/groups/:group_id/discussion_topics/:topic_id/read_all`
///
/// Mark the discussion topic and all its entries as read.
///
/// No request fields are necessary.
///
/// On success, the response will be 204 No Content with an empty body.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.mark_all_read
///
/// Replies will be marked as read as well.
Future<bool> markAllEntriesAsRead(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? forcedReadState,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/read_all';
  var p = [
    ['forced_read_state', forcedReadState],
  ];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Mark all entries as unread
///
/// `DELETE /api/v1/courses/:course_id/discussion_topics/:topic_id/read_all`
///
/// `DELETE /api/v1/groups/:group_id/discussion_topics/:topic_id/read_all`
///
/// Mark the discussion topic and all its entries as unread.
///
/// No request fields are necessary.
///
/// On success, the response will be 204 No Content with an empty body.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.mark_all_unread
///
/// Replies will be marked as unread as well.
Future<bool> markAllEntriesAsUnread(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? forcedReadState,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'DELETE';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/read_all';
  var p = [
    ['forced_read_state', forcedReadState],
  ];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Mark entry as read
///
/// `PUT /api/v1/courses/:course_id/discussion_topics/:topic_id/entries/:entry_id/read`
///
/// `PUT /api/v1/groups/:group_id/discussion_topics/:topic_id/entries/:entry_id/read`
///
/// Mark a discussion entry as read.
///
/// No request fields are necessary.
///
/// On success, the response will be 204 No Content with an empty body.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.mark_entry_read
///
/// Replies can be marked as read as well.
Future<bool> markEntryAsRead(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  required Object? entryId,
  Object? forcedReadState,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var url =
      '/api/v1/$context/$contextId/discussion_topics/$topicId/entries/$entryId/read';
  var p = [
    ['forced_read_state', forcedReadState],
  ];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Mark entry as unread
///
/// `DELETE /api/v1/courses/:course_id/discussion_topics/:topic_id/entries/:entry_id/read`
///
/// `DELETE /api/v1/groups/:group_id/discussion_topics/:topic_id/entries/:entry_id/read`
///
/// Mark a discussion entry as unread.
///
/// No request fields are necessary.
///
/// On success, the response will be 204 No Content with an empty body.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.mark_entry_unread
///
/// Replies can be marked as unread as well.
Future<bool> markEntryAsUnread(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  required Object? entryId,
  Object? forcedReadState,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'DELETE';
  var url =
      '/api/v1/$context/$contextId/discussion_topics/$topicId/entries/$entryId/read';
  var p = [
    ['forced_read_state', forcedReadState],
  ];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Rate entry
///
/// `POST /api/v1/courses/:course_id/discussion_topics/:topic_id/entries/:entry_id/rating`
///
/// `POST /api/v1/groups/:group_id/discussion_topics/:topic_id/entries/:entry_id/rating`
///
/// Rate a discussion entry.
///
/// On success, the response will be 204 No Content with an empty body.
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.rate_entry
///
/// Replies may be rated as well.
Future<bool> rateEntry(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  required Object? entryId,
  Object? rating,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var p = [
    ['rating', rating],
  ];
  var url =
      '/api/v1/$context/$contextId/discussion_topics/$topicId/entries/$entryId/rating';
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Subscribe to a topic
///
/// `PUT /api/v1/courses/:course_id/discussion_topics/:topic_id/subscribed`
///
/// `PUT /api/v1/groups/:group_id/discussion_topics/:topic_id/subscribed`
///
/// Subscribe to a topic to receive notifications about new entries
///
/// On success, the response will be 204 No Content with an empty body
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.subscribe_topic
Future<bool> subscribeToTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/subscribed';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}

/// Unsubscribe from a topic
///
/// `DELETE /api/v1/courses/:course_id/discussion_topics/:topic_id/subscribed`
///
/// `DELETE /api/v1/groups/:group_id/discussion_topics/:topic_id/subscribed`
///
/// Unsubscribe from a topic to stop receiving notifications about new entries
///
/// On success, the response will be 204 No Content with an empty body
///
/// https://canvas.instructure.com/doc/api/discussion_topics.html#method.discussion_topics_api.unsubscribe_topic
Future<bool> unsubscribeFromTopic(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? topicId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'DELETE';
  var url = '/api/v1/$context/$contextId/discussion_topics/$topicId/subscribed';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var response = tmp.item1;
  return response.statusCode == 204;
}
