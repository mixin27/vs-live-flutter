import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'football_highlight.g.dart';

@JsonSerializable(createToJson: false)
@immutable
class FootballHighlight extends Equatable {
  const FootballHighlight({
    required this.title,
    required this.embed,
    required this.url,
    required this.thumbnail,
    required this.date,
    required this.side1,
    required this.side2,
    required this.competition,
    required this.videos,
  });

  final String title;
  final String embed;
  final String url;
  final String thumbnail;
  final String date;

  final HighlightSide side1;
  final HighlightSide side2;
  final HighlightCompetition competition;

  @JsonKey(defaultValue: [])
  final List<HighlightVideo> videos;

  factory FootballHighlight.fromJson(Map<String, dynamic> json) =>
      _$FootballHighlightFromJson(json);

  @override
  List<Object?> get props => [title, embed, url, thumbnail, date];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
@immutable
class HighlightSide extends Equatable {
  const HighlightSide({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory HighlightSide.fromJson(Map<String, dynamic> json) =>
      _$HighlightSideFromJson(json);

  @override
  List<Object?> get props => [name, url];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
@immutable
class HighlightCompetition extends Equatable {
  const HighlightCompetition({
    required this.id,
    required this.name,
    required this.url,
  });

  final int id;
  final String name;
  final String url;

  factory HighlightCompetition.fromJson(Map<String, dynamic> json) =>
      _$HighlightCompetitionFromJson(json);

  @override
  List<Object?> get props => [id, name, url];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
@immutable
class HighlightVideo extends Equatable {
  const HighlightVideo({
    required this.title,
    required this.embed,
  });

  final String title;
  final String embed;

  factory HighlightVideo.fromJson(Map<String, dynamic> json) =>
      _$HighlightVideoFromJson(json);

  @override
  List<Object?> get props => [title, embed];

  @override
  bool? get stringify => true;
}
