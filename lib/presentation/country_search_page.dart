import 'package:countries/model/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountrySearch extends StatefulWidget {
  const CountrySearch({Key? key}) : super(key: key);

  @override
  _CountrySearchState createState() => _CountrySearchState();
}

class _CountrySearchState extends State<CountrySearch> {
  late CountryProvider countryProvider;
  TextEditingController controller = TextEditingController();
  String? code;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    countryProvider = Provider.of<CountryProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF67280),
          title: const Text('Language'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              code != null
                  ? ListTile(
                      title: Text(code!),
                      trailing: InkWell(
                        onTap: () {
                          code = null;
                          setState(() {});
                        },
                        child: const Text('Clear'),
                      ),
                    )
                  : Column(
                      children: [
                        TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Country Code',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () async {
                            code = await (countryProvider.getCountryNameByCode(
                                context,
                                code: controller.text.trim().toUpperCase()));
                            controller.clear();
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
