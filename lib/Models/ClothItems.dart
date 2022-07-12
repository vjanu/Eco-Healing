class Clothitems {
  String? name;
  String? address;
  String? cost;
  String? details;

  Clothitems({
    this.name,
    this.address,
    this.cost,
    this.details,
  });

  static Clothitems fromJSON(Map<String, dynamic> json) => Clothitems(
        name: json["name"],
        address: json["address"],
        cost: json["cost"],
        details: json["details"],
      );

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["name"] = name;
    data["address"] = address;
    data["cost"] = cost;

    return data;
  }
}
