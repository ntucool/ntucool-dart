import 'dart:io' show HttpHeaders;

import 'package:tuple/tuple.dart' show Tuple2;

import 'rfc5234.dart' show DQUOTE;
import 'rfc7230.dart' show BWS, OWS, RWS;

// B. Algorithms for Parsing Link Header Fields
// https://httpwg.org/specs/rfc8288.html#parse

/// B.1. Parsing a Header Set for Links
/// https://httpwg.org/specs/rfc8288.html#parse-set
parseAHeaderSetForLinks(HttpHeaders httpHeaders) {
  var fieldValues = httpHeaders['link'];
  if (fieldValues == null) {
    return null;
  }
  var links = [];
  for (var fieldValue in fieldValues) {
    var valueLinks = parseALinkFieldValue(fieldValue);
    links.add(valueLinks);
  }
  return links;
}

/// B.2. Parsing a Link Field Value
/// https://httpwg.org/specs/rfc8288.html#parse-fv
parseALinkFieldValue(String fieldValue) {
  var links = [];
  while (fieldValue.isNotEmpty) {
    var leadingOWS = OWS.matchAsPrefix(fieldValue);
    if (leadingOWS != null) {
      fieldValue = fieldValue.substring(leadingOWS.end);
    }
    if (fieldValue[0] != "<") {
      return links;
    }
    fieldValue = fieldValue.substring("<".length);
    var index = fieldValue.indexOf(">");
    if (index == -1) {
      return links;
    }
    var targetString = fieldValue.substring(0, index);
    fieldValue = fieldValue.substring(index + ">".length);
    var tmp = parsingParameters(fieldValue);
    var linkParameters = tmp.item1;
    fieldValue = tmp.item2;
    // TODO: Let target_uri be the result of relatively resolving (as per [RFC3986], Section 5.2) target_string. Note that any base URI carried in the payload body is NOT used.
    var targetUri = targetString;
    var relationString = '';
    for (var element in linkParameters) {
      var paramName = element.key;
      if (paramName == 'rel') {
        var paramValue = element.value;
        relationString = paramValue;
        break;
      }
    }
    var relationTypes = relationString.split(RWS);
    String? contextString;
    for (var element in linkParameters) {
      var paramName = element.key;
      if (paramName == 'anchor') {
        var paramValue = element.value;
        contextString = paramValue;
        break;
      }
    }
    // TODO: Let context_string be the second item of the first tuple of link_parameters whose first item matches the string “anchor”. If it is not present, context_string is the URL of the representation carrying the Link header [RFC7231], Section 3.1.4.1, serialised as a URI. Where the URL is anonymous, context_string is null.
    // TODO: Let context_uri be the result of relatively resolving (as per [RFC3986], Section 5.2) context_string, unless context_string is null, in which case context is null. Note that any base URI carried in the payload body is NOT used.
    var contextUri = contextString;
    var targetAttributes = <MapEntry<String, String>>[];
    for (var element in linkParameters) {
      var paramName = element.key;
      if (paramName == 'rel' || paramName == 'anchor') {
        continue;
      }
      if (paramName == 'media' ||
          paramName == 'title' ||
          paramName == 'title*' ||
          paramName == 'type') {
        if (targetAttributes.any((element) => element.key == paramName)) {
          continue;
        }
      }
      targetAttributes.add(element);
    }
    var starParamNames = Set<String>.from(linkParameters
        .where((value) =>
            value.key.length > 0 && value.key[value.key.length - 1] == "*")
        .map<String>((e) => e.key));
    for (var starParamName in starParamNames) {
      var baseParamName = starParamName.substring(starParamName.length - 1);
      linkParameters = linkParameters
          .where((element) => element.key == baseParamName)
          .toList();
      linkParameters = linkParameters.map((e) {
        if (e.key == starParamName) {
          return MapEntry(baseParamName, e.value);
        } else {
          return e;
        }
      }).toList();
    }
    for (var relationType in relationTypes) {
      relationType = relationType.toLowerCase();
      links.add({
        'target': targetUri,
        'relationType': relationType,
        'context': contextUri,
        'targetAttributes': targetAttributes,
      });
    }
  }
  return links;
}

/// B.3. Parsing Parameters
/// https://httpwg.org/specs/rfc8288.html#parse-param
Tuple2<List<MapEntry<String, String>>, String> parsingParameters(String input) {
  var parameters = <MapEntry<String, String>>[];
  while (input.isNotEmpty) {
    var leadingOWS = OWS.matchAsPrefix(input);
    if (leadingOWS != null) {
      input = input.substring(leadingOWS.end);
    }
    if (input[0] != ";") {
      return Tuple2(parameters, input);
    }
    input = input.substring(1);
    leadingOWS = OWS.matchAsPrefix(input);
    if (leadingOWS != null) {
      input = input.substring(leadingOWS.end);
    }
    String parameterName;
    var match = RegExp('(?:' + BWS.pattern + '|[' + RegExp.escape("=;,") + '])')
        .firstMatch(input);
    if (match == null) {
      parameterName = input;
      input = '';
    } else {
      parameterName = input.substring(0, match.start);
      input = input.substring(match.start);
    }
    var leadingBWS = BWS.matchAsPrefix(input);
    if (leadingBWS != null) {
      input = input.substring(leadingBWS.end);
    }
    String parameterValue;
    if (input[0] == "=") {
      input = input.substring(1);
      leadingBWS = BWS.matchAsPrefix(input);
      if (leadingBWS != null) {
        input = input.substring(leadingBWS.end);
      }
      if (input[0] == DQUOTE) {
        var tmp = parsingAQuotedString(input);
        parameterValue = tmp.item1;
        input = tmp.item2;
      } else {
        match = RegExp('[' + RegExp.escape(";,") + ']').firstMatch(input);
        if (match == null) {
          parameterValue = input;
          input = '';
        } else {
          parameterValue = input.substring(0, match.start);
          input = input.substring(match.start);
        }
      }
      if (parameterName[parameterName.length - 1] == "*") {
        // TODO: If the last character of parameter_name is an asterisk (“*”), decode parameter_value according to [RFC8187]. Continue processing input if an unrecoverable error is encountered.
      }
    } else {
      parameterValue = '';
    }
    parameterName = parameterName.toLowerCase();
    parameters.add(MapEntry(parameterName, parameterValue));
    leadingOWS = OWS.matchAsPrefix(input);
    if (leadingOWS != null) {
      input = input.substring(leadingOWS.end);
    }
    if (input[0] == "," || input.isEmpty) {
      return Tuple2(parameters, input);
    }
  }
  return Tuple2(parameters, input);
}

/// B.4. Parsing a Quoted String
/// https://httpwg.org/specs/rfc8288.html#parse-qs
Tuple2<String, String> parsingAQuotedString(String input) {
  var output = '';
  if (!input.startsWith(DQUOTE)) {
    return Tuple2(output, input);
  }
  input = input.substring(DQUOTE.length);
  while (input.isNotEmpty) {
    if (input[0] == "\\") {
      input = input.substring(1);
      if (input.isEmpty) {
        return Tuple2(output, input);
      } else {
        output += input[1];
        input = input.substring(1);
      }
    } else if (input[0] == DQUOTE) {
      input = input.substring(1);
      return Tuple2(output, input);
    } else {
      output += input[1];
      input = input.substring(1);
    }
  }
  return Tuple2(output, input);
}
