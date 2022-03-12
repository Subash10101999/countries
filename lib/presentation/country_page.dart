import 'package:countries/model/country.dart';
import 'package:countries/model/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'country_search_page.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  late CountryProvider _countryProvider;
  final List<CountryElement> _countries = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _countryProvider.getCountryName();
      await _countryProvider.getLanguages();
    });
  }

  @override
  void dispose() {
    _countryProvider.countries!.clear();
    _countryProvider.languages.clear();
    _countries.clear();

    super.dispose();
  }

  _filterDialogBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            title: const Text('Filter'),
            content: SizedBox(
              height: 400,
              width: 300,
              child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return const Divider();
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _countryProvider.languages.length,
                  itemBuilder: (context, index) {
                    final name = _countryProvider.languages[index].name!;
                    return ListTile(
                      onTap: () async {
                        await _filter(name);
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      title: Text(name),
                    );
                  }),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future _filter(languageName) async {
    List<CountryElement> _temp = [];
    _temp.addAll(_countryProvider.countries!);
    for (var v in _temp) {
      for (var l in v.languages!) {
        if (l.name!.toLowerCase().contains(languageName.toLowerCase())) {
          _countries.add(v);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _countryProvider = Provider.of<CountryProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: const Color(0xFFF67280),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: const Text('Country'),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                      ),
                      readOnly: true,
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (_) => const CountrySearch());
                        Navigator.push(context, route);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _countries.isEmpty
              ? _filterDialogBox
              : () {
                  _countries.clear();
                  setState(() {});
                },
          child: Text(_countries.isEmpty ? 'Filter' : 'Clear'),
        ),
        body: Column(
          children: [
            Expanded(
              child: _countryProvider.countries!.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _countries.isEmpty
                      ? ListView.separated(
                          separatorBuilder: (_, index) {
                            return const Divider();
                          },
                          itemCount: _countryProvider.countries!.length,
                          itemBuilder: (context, index) {
                            final countryName =
                                _countryProvider.countries![index].name!;
                            final countryLanguage =
                                _countryProvider.countries![index].languages!;
                            return ListTile(
                              title: Text(countryName),
                              trailing: countryLanguage.isNotEmpty
                                  ? Text(countryLanguage[0].name!)
                                  : const SizedBox(),
                            );
                          })
                      : ListView.separated(
                          separatorBuilder: (_, index) {
                            return const Divider();
                          },
                          itemCount: _countries.length,
                          itemBuilder: (context, index) {
                            final countryName = _countries[index].name!;
                            final countryLanguage =
                                _countries[index].languages!;
                            return ListTile(
                              title: Text(countryName),
                              subtitle: countryLanguage.isNotEmpty
                                  ? Text(countryLanguage[0].name!)
                                  : const SizedBox(),
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }
}