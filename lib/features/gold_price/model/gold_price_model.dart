class GoldPriceModel {
  final String name;
  final String sell;
  final String buy;

  GoldPriceModel({required this.name, required this.sell, required this.buy});

  factory GoldPriceModel.fromJson(Map<String, dynamic> json) =>
      GoldPriceModel(name: json["name"], sell: json["sell"], buy: json["buy"]);

  Map<String, dynamic> toJson() => {"name": name, "sell": sell, "buy": buy};
}
