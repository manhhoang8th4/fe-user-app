class User {
  String? sId;
  String? name;
  String? password;
  String? createdAt;
  String? updatedAt;
  String? playerId;
  int? iV;

  User(
      {this.sId,
      this.name,
      this.password,
      this.createdAt,
      this.updatedAt,
      this.playerId,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    playerId = json['playerId'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['playerId'] = playerId;
    data['__v'] = this.iV;
    return data;
  }
}
