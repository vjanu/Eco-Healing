class Electronicitems {
  String? name;
  String? address;
  String? cost;

  Electronicitems({
    this.name,
    this.address,
    this.cost,
  });

  static Electronicitems fromJSON(Map<String, dynamic> json) => Electronicitems(
        name: json["name"],
        address: json["address"],
        cost: json["cost"],
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
