class MatchInfoModel {
  final String matchId;
  final String leagueName;
  final Team teamOne;
  final Team teamTwo;
  final MatchStatus matchStatus;
  final MatchInfo matchInfo;

  MatchInfoModel({
    required this.matchId,
    required this.leagueName,
    required this.teamOne,
    required this.teamTwo,
    required this.matchStatus,
    required this.matchInfo,
  });

  factory MatchInfoModel.fromJson(Map<String, dynamic> json) => MatchInfoModel(
    matchId: json["match_id"],
    leagueName: json["league_name"],
    teamOne: Team.fromJson(json["team_one"]),
    teamTwo: Team.fromJson(json["team_two"]),
    matchStatus: MatchStatus.fromJson(json["match_status"]),
    matchInfo: MatchInfo.fromJson(json["match_info"]),
  );

  Map<String, dynamic> toJson() => {
    "match_id": matchId,
    "league_name": leagueName,
    "team_one": teamOne.toJson(),
    "team_two": teamTwo.toJson(),
    "match_status": matchStatus.toJson(),
    "match_info": matchInfo.toJson(),
  };
}

class MatchInfo {
  final String stadium;
  final String date;
  final String channel;
  final String commentator;

  MatchInfo({
    required this.stadium,
    required this.date,
    required this.channel,
    required this.commentator,
  });

  factory MatchInfo.fromJson(Map<String, dynamic> json) => MatchInfo(
    stadium: json["stadium"],
    date: json["date"],
    channel: json["channel"],
    commentator: json["commentator"],
  );

  Map<String, dynamic> toJson() => {
    "stadium": stadium,
    "date": date,
    "channel": channel,
    "commentator": commentator,
  };
}

class MatchStatus {
  final String status;
  final String fullStatus;
  final String time;

  MatchStatus({
    required this.status,
    required this.fullStatus,
    required this.time,
  });

  factory MatchStatus.fromJson(Map<String, dynamic> json) => MatchStatus(
    status: json["status"],
    fullStatus: json["full_status"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "full_status": fullStatus,
    "time": time,
  };
}

class Team {
  final String name;
  final String image;
  final String score;
  final String coach;
  final List<Goal> goals;

  Team({
    required this.name,
    required this.image,
    required this.score,
    required this.coach,
    required this.goals,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    name: json["name"],
    image: json["image"],
    score: json["score"],
    coach: json["coach"],
    goals: List<Goal>.from(json["goals"].map((x) => Goal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "score": score,
    "coach": coach,
    "goals": List<dynamic>.from(goals.map((x) => x.toJson())),
  };
}

class Goal {
  final String scorer;
  final String minute;

  Goal({required this.scorer, required this.minute});

  factory Goal.fromJson(Map<String, dynamic> json) =>
      Goal(scorer: json["scorer"], minute: json["minute"]);

  Map<String, dynamic> toJson() => {"scorer": scorer, "minute": minute};
}
