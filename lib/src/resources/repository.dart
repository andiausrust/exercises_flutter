import 'dart:async';
import './news_api_provider.dart';
import './news_db_provider.dart';
import '../model/item_model.dart';
import 'news_api_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    NewsApiProvider(),
    newsDbProvider,
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    Source source;
    ItemModel itemModel;
    for(source in sources) {
      itemModel = await source.fetchItem(id);
      if(itemModel != null)
        break;
    }

    for(var cache in caches) {
      cache.addItem(itemModel);
    }
    return itemModel;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  addItem(ItemModel item);
}