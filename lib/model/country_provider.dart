import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../network/api.dart';
import 'country.dart';


class CountryProvider extends ChangeNotifier {
  final Api _api = Api();
  List<CountryElement>? _countries = [];
  final List<Language> _languages = [];
  CountryElement? _country;

  List<CountryElement>? get countries => _countries;
  List<Language> get languages => _languages;

  CountryElement? get country => _country;

  Future getCountryName() async {
    final result = await _api.getCountries();
    final decode = jsonDecode(result);
    final parse = Data.fromJson(decode);
    _countries = parse.countries;
    _countries!.sort((a, b) => a.name!.compareTo(b.name!));

    notifyListeners();
  }

  Future getLanguages() async {
    final result = await _api.getLanguages();
    final decode = jsonDecode(result);
    for(var l in decode) {
      languages.add(Language.fromJson(l));
    }

    notifyListeners();
  }

  Future getCountryNameByCode(context, {String? code}) async {
    final result = await _api.getCountryByCode(context, code: code);
    if (result != null) {
      final decode = jsonDecode(result);
      if (decode['country'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Country Code doesn't exists"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      final parse = CountryElement.fromJson(decode['country']);
      _country = parse;

      notifyListeners();
      return parse.name;
    }
  }
}
