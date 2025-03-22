import 'dart:convert';

PlansModel plansModelFromJson(String str) =>
    PlansModel.fromJson(json.decode(str));

String plansModelToJson(PlansModel data) => json.encode(data.toJson());

class PlansModel {
  final String? id;
  final String? plan;
  final List<String>? description;
  final int? v;
  final String? plansModelId;

  PlansModel({
    this.id,
    this.plan,
    this.description,
    this.v,
    this.plansModelId,
  });

  PlansModel copyWith({
    String? id,
    String? plan,
    List<String>? description,
    int? v,
    String? plansModelId,
  }) =>
      PlansModel(
        id: id ?? this.id,
        plan: plan ?? this.plan,
        description: description ?? this.description,
        v: v ?? this.v,
        plansModelId: plansModelId ?? this.plansModelId,
      );

  factory PlansModel.fromJson(Map<String, dynamic> json) => PlansModel(
        id: json["_id"],
        plan: json["plan"],
        description: json["description"] == null
            ? []
            : List<String>.from(json["description"]!.map((x) => x)),
        v: json["__v"],
        plansModelId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "plan": plan,
        "description": description == null
            ? []
            : List<dynamic>.from(description!.map((x) => x)),
        "__v": v,
        "id": plansModelId,
      };
}
