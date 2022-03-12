import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../network/gql_base_client.dart';
import 'country.dart';
import 'language.dart';

class CountryProvider extends ChangeNotifier {
  final GglBaseClient _api = GglBaseClient();
  List<Country>? _countries = [];
  final List<Language> _languages = [];
  Country? _country;

  List<Country>? get countries => _countries;

  List<Language> get languages => _languages;

  Country? get country => _country;

  Future fetchCountryName() async {
    final result = await _api.fetchCountries();
    _countries =
        result["countries"].map<Country>((x) => Country.fromJson(x)).toList();
    _countries!.sort((a, b) => a.name!.compareTo(b.name!));
    notifyListeners();
  }

  Future fetchLanguages() async {
    final result = await _api.fetchLanguages();
    for (var language in result) {
      languages.add(Language.fromJson(language));
    }

    notifyListeners();
  }

  Future fetchCountryNameByCode(context, {String? code}) async {
    final result = await _api.fetchCountryByCode(context, code: code);
    if (result != null) {
      if (result['country'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Country Code doesn't exists",
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.grey,
        ));
        return;
      }
      final parse = Country.fromJson(result['country']);
      _country = parse;

      notifyListeners();
      return parse.name;
    }
  }
}
