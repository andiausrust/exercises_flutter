import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:hackr_api/src/resources/news_api_provider.dart';

void main() {
  test('FetchTopIds returns a list of ids', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1,2,3,4]), 200);
    });

    final ids = await newsApi.fetchTopIds();
    expect(ids, [1, 2 ,3 ,4]);
  });

  test('fetchItem returns a item model', () {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });
    final item = newsApi.fetchItem(999);
    expect(item.id, 123);
  });

}

