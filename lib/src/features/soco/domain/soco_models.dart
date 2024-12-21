import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'soco_models.g.dart';

@JsonSerializable(createToJson: false)
class SocoLiveModel extends Equatable {
  const SocoLiveModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SocoLiveModel.fromJson(Map<String, dynamic> json) =>
      _$SocoLiveModelFromJson(json);

  final bool success;
  final String message;

  @JsonKey(defaultValue: [])
  final List<SocoLiveMatch> data;

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
class SocoLiveMatch extends Equatable {
  const SocoLiveMatch({
    required this.matchTime,
    required this.matchStatus,
    required this.homeTeamName,
    required this.homeTeamLogo,
    required this.awayTeamName,
    required this.awayTeamLogo,
    required this.leaguename,
    required this.servers,
  });

  factory SocoLiveMatch.fromJson(Map<String, dynamic> json) =>
      _$SocoLiveMatchFromJson(json);

  @JsonKey(name: 'match_time')
  final String matchTime;

  @JsonKey(name: 'match_status')
  final String matchStatus;

  @JsonKey(name: 'home_team_name')
  final String homeTeamName;

  @JsonKey(name: 'home_team_logo')
  final String homeTeamLogo;

  @JsonKey(name: 'away_team_name')
  final String awayTeamName;

  @JsonKey(name: 'away_team_logo')
  final String awayTeamLogo;

  @JsonKey(name: 'league_name')
  final String leaguename;

  @JsonKey(defaultValue: [])
  final List<SocoLiveServer> servers;

  @override
  List<Object?> get props =>
      [matchTime, matchStatus, homeTeamName, awayTeamName];

  @override
  bool? get stringify => true;
}

@JsonSerializable(createToJson: false)
class SocoLiveServer extends Equatable {
  const SocoLiveServer({
    required this.title,
    required this.name,
    required this.room,
    required this.cover,
    required this.streamUrl,
  });

  factory SocoLiveServer.fromJson(Map<String, dynamic> json) =>
      _$SocoLiveServerFromJson(json);

  final String title;
  final String name;
  final String room;
  final String cover;

  @JsonKey(name: 'stream_url')
  final String streamUrl;

  @override
  List<Object?> get props => [title, name, room, streamUrl];

  @override
  bool? get stringify => true;
}
