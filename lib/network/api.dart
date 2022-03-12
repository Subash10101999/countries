import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Api {
  late GraphQLClient gqlClient;

  Api() {
    gqlClient = GraphQLClient(
      link: AuthLink(getToken: () => "").concat(HttpLink(
        'https://countries.trevorblades.com/graphql',
      )),
      cache: GraphQLCache(),
    );
  }

  Future fetchCountries() async {
    const String query = '''
    query {
      countries {
        name
        languages {
          code
          name
        }
      }
    }
  ''';
    final QueryResult result = await gqlClient.query(
      QueryOptions(
        document: gql(query),
      ),
    );

    return json.encode(result.data);
  }

  Future fetchLanguages() async {
    const String query = '''
    query Query {
      languages {
        name
        code
      }
    }
  ''';
    final QueryResult result = await gqlClient.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    return json.encode(result.data!['languages']);
  }

  Future fetchCountryByCode(context, {String? code}) async {
    final String query = '''
    query Query {
      country(code: "$code") {
      name
      }
    }
  ''';
    final QueryResult result = await gqlClient.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Country Code doesn't exists",
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.grey,
      ));
      return null;
    }

    return json.encode(result.data);
  }
}
