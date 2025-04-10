class MatchesModel {
  final String leagueName;
  final List<Match> matches;

  MatchesModel({required this.leagueName, required this.matches});

  factory MatchesModel.fromJson(Map<String, dynamic> json) => MatchesModel(
    leagueName: json["league_name"],
    matches: List<Match>.from(json["matches"].map((x) => Match.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "league_name": leagueName,
    "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
  };
}

class Match {
  final Team teamOne;
  final Team teamTwo;
  final String matchId;
  final String status;
  final Info info;

  Match({
    required this.teamOne,
    required this.teamTwo,
    required this.matchId,
    required this.status,
    required this.info,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    teamOne: Team.fromJson(json["team_one"]),
    teamTwo: Team.fromJson(json["team_two"]),
    matchId: json["match_id"],
    status: json["status"],
    info: Info.fromJson(json["info"]),
  );

  Map<String, dynamic> toJson() => {
    "team_one": teamOne.toJson(),
    "team_two": teamTwo.toJson(),
    "match_id": matchId,
    "status": status,
    "info": info.toJson(),
  };
}

class Info {
  final String datetime;
  final String channel;
  final String stadium;

  Info({required this.datetime, required this.channel, required this.stadium});

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    datetime: json["datetime"],
    channel: json["channel"],
    stadium: json["stadium"],
  );

  Map<String, dynamic> toJson() => {
    "datetime": datetime,
    "channel": channel,
    "stadium": stadium,
  };
}

class Team {
  final String name;
  final String score;
  final String image;

  Team({required this.name, required this.score, required this.image});

  factory Team.fromJson(Map<String, dynamic> json) =>
      Team(name: json["name"], score: json["score"], image: json["image"]);

  Map<String, dynamic> toJson() => {
    "name": name,
    "score": score,
    "image": image,
  };
}
