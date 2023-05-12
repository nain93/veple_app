import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:veple/models/item_model.dart';
import 'package:veple/repositories/item_repository.dart';

part 'item_provider.g.dart';

/// AsyncNotifierProvider
// @Riverpod(keepAlive: true)
@riverpod
class AsyncItems extends _$AsyncItems {
  Future<List<ItemModel>> fetchItem() async {
    // get the [KeepAliveLink]
    var link = ref.keepAlive();
    // a timer to be used by the callbacks below
    Timer? timer;
    // An object from package:dio that allows cancelling http requests
    // When the provider is destroyed, cancel the http request and the timer
    ref.onDispose(() {
      timer?.cancel();
    });
    // When the last listener is removed, start a timer to dispose the cached data
    ref.onCancel(() {
      // start a 30 second timerㅜ
      timer = Timer(const Duration(seconds: 30), () {
        // dispose on timeout
        link.close();
      });
    });
    // If the provider is listened again after it was paused, cancel the timer
    ref.onResume(() {
      timer?.cancel();
    });

    var itemData = ItemRepository.instance.getItems();
    return itemData;
  }

  @override
  Future<List<ItemModel>> build() async {
    return fetchItem();
  }

  Future<void> addItems({
    required ItemModel item,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ItemRepository.instance.addItem(item: item);
      return fetchItem();
    });
  }

  Future<void> removeItems({
    required int id,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ItemRepository.instance.removeItem(id: id);
      return fetchItem();
    });
  }

  Future<void> updateItems({
    required ItemModel item,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ItemRepository.instance.updateItem(item: item);
      return fetchItem();
    });
  }
}
