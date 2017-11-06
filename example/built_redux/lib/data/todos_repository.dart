import 'dart:async';
import 'dart:core';
import 'package:built_redux_sample/data/file_storage.dart';
import 'package:built_redux_sample/data/web_service.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:path_provider/path_provider.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
///
/// In most apps, we use the provided repository. In this case, it makes sense
/// to demonstrate the built_value serializers, which are used in the
/// FileStorage part of this app.
class TodosRepository {
  final FileStorage fileStorage;
  final WebClient webClient;

  const TodosRepository({
    this.fileStorage = const FileStorage(
      '__built_redux__',
      getApplicationDocumentsDirectory,
    ),
    this.webClient = const WebClient(),
  });

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Service.
  Future<List<Todo>> loadTodos() async {
    try {
      return await fileStorage.loadTodos();
    } catch (e) {
      return webClient.fetchTodos();
    }
  }

  // Persists todos to local disk and the web
  Future saveTodos(List<Todo> todos) {
    return Future.wait([
      fileStorage.saveTodos(todos),
      webClient.postTodos(todos),
    ]);
  }
}