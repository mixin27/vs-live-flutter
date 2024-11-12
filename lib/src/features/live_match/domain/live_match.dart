import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_match.g.dart';

@JsonSerializable(createToJson: false)
@immutable
class LiveMatch extends Equatable {
  const LiveMatch({
    required this.id,
    required this.startedDate,
    required this.startedTime,
    required this.liveStatus,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.links,
  });

  final int id;

  @JsonKey(name: "started_date")
  final String startedDate;

  @JsonKey(name: "started_time")
  final String startedTime;

  @JsonKey(name: "live_status", defaultValue: false)
  final bool liveStatus;

  @JsonKey(name: 'home_team')
  final FootballTeam homeTeam;

  @JsonKey(name: 'away_team')
  final FootballTeam awayTeam;

  final FootballLeague league;

  @JsonKey(defaultValue: [])
  final List<LiveLink> links;

  factory LiveMatch.fromJson(Map<String, dynamic> json) =>
      _$LiveMatchFromJson(json);

  @override
  List<Object?> get props => [id, startedDate, startedTime];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
@immutable
class FootballTeam extends Equatable {
  const FootballTeam({
    required this.id,
    required this.name,
    required this.logo,
    this.shortName,
  });

  final int id;
  final String name;
  final String logo;
  @JsonKey(name: "short_name")
  final String? shortName;

  factory FootballTeam.fromJson(Map<String, dynamic> json) =>
      _$FootballTeamFromJson(json);

  @override
  List<Object?> get props => [id, name, logo, shortName];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
@immutable
class FootballLeague extends Equatable {
  const FootballLeague({
    required this.id,
    required this.name,
    required this.logo,
  });

  final int id;
  final String name;
  final String logo;

  factory FootballLeague.fromJson(Map<String, dynamic> json) =>
      _$FootballLeagueFromJson(json);

  @override
  List<Object?> get props => [id, name, logo];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
@immutable
class LiveLink extends Equatable {
  const LiveLink({
    required this.id,
    required this.name,
    required this.url,
    required this.resolution,
    required this.matchId,
    this.type,
  });

  final int id;
  final String name;
  final String url;
  final String resolution;

  @JsonKey(name: 'link_type')
  final LiveLinkType? type;

  @JsonKey(name: "match_id")
  final int matchId;

  factory LiveLink.fromJson(Map<String, dynamic> json) =>
      _$LiveLinkFromJson(json);

  @override
  List<Object?> get props => [id, name, url, matchId, resolution];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
@immutable
class LiveLinkType extends Equatable {
  const LiveLinkType({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory LiveLinkType.fromJson(Map<String, dynamic> json) =>
      _$LiveLinkTypeFromJson(json);

  @override
  List<Object?> get props => [id, name];

  @override
  bool? get stringify => true;
}
