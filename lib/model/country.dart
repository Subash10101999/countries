import 'language.dart';

class Country {
  Country({
    this.name,
    this.languages,
  });

  String? name;
  List<Language>? languages;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: json["name"],
        languages: json["languages"] != null
            ? List<Language>.from(
                json["languages"].map((x) => Language.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "languages": List<dynamic>.from(languages!.map((x) => x.toJson())),
      };
}