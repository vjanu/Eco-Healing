class Fooditems {
  String? name;
  String? address;
  String? cost;

  Fooditems({
    this.name,
    this.address,
    this.cost,
  });

  static Fooditems fromJSON(Map<String, dynamic> json) => Fooditems(
        name: json["name"],
        address: json["address"],
        cost: json["project cost"],
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
