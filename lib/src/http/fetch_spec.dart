import 'dart:io' show HttpHeaders, HttpStatus;

// https://fetch.spec.whatwg.org/#statuses

// https://fetch.spec.whatwg.org/#concept-status
bool isStatus(int status) => 0 <= status && status <= 999;

// https://fetch.spec.whatwg.org/#null-body-status
const nullBodyStatus = [
  HttpStatus.switchingProtocols,
  HttpStatus.noContent,
  HttpStatus.resetContent,
  HttpStatus.notModified,
];
bool isNullBodyStatus(int status) => nullBodyStatus.contains(status);

// https://fetch.spec.whatwg.org/#ok-status
bool isOkStatus(int status) => 200 <= status && status <= 299;

// https://fetch.spec.whatwg.org/#redirect-status
const redirectStatus = [
  HttpStatus.movedPermanently,
  HttpStatus.found,
  HttpStatus.seeOther,
  HttpStatus.temporaryRedirect,
  HttpStatus.permanentRedirect,
];
bool isRedirectStatus(int status) => redirectStatus.contains(status);

// https://fetch.spec.whatwg.org/#request-body-header-name
const requestBodyHeaderName = [
  HttpHeaders.contentEncodingHeader,
  HttpHeaders.contentLanguageHeader,
  HttpHeaders.contentLocationHeader,
  HttpHeaders.contentTypeHeader,
];
