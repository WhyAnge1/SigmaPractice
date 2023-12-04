// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorMobileDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MobileDatabaseBuilder databaseBuilder(String name) =>
      _$MobileDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MobileDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$MobileDatabaseBuilder(null);
}

class _$MobileDatabaseBuilder {
  _$MobileDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$MobileDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$MobileDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<MobileDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$MobileDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$MobileDatabase extends MobileDatabase {
  _$MobileDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CommentDao? _commentDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CommentModel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `ownerId` TEXT NOT NULL, `rating` REAL NOT NULL, `comment` TEXT NOT NULL, `ownerName` TEXT NOT NULL, `ownerPhotoUrl` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CommentDao get commentDao {
    return _commentDaoInstance ??= _$CommentDao(database, changeListener);
  }
}

class _$CommentDao extends CommentDao {
  _$CommentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _commentModelInsertionAdapter = InsertionAdapter(
            database,
            'CommentModel',
            (CommentModel item) => <String, Object?>{
                  'id': item.id,
                  'ownerId': item.ownerId,
                  'rating': item.rating,
                  'comment': item.comment,
                  'ownerName': item.ownerName,
                  'ownerPhotoUrl': item.ownerPhotoUrl
                }),
        _commentModelDeletionAdapter = DeletionAdapter(
            database,
            'CommentModel',
            ['id'],
            (CommentModel item) => <String, Object?>{
                  'id': item.id,
                  'ownerId': item.ownerId,
                  'rating': item.rating,
                  'comment': item.comment,
                  'ownerName': item.ownerName,
                  'ownerPhotoUrl': item.ownerPhotoUrl
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CommentModel> _commentModelInsertionAdapter;

  final DeletionAdapter<CommentModel> _commentModelDeletionAdapter;

  @override
  Future<List<CommentModel>> getAllComments() async {
    return _queryAdapter.queryList('SELECT * FROM CommentModel',
        mapper: (Map<String, Object?> row) => CommentModel(
            id: row['id'] as int?,
            ownerId: row['ownerId'] as String,
            rating: row['rating'] as double,
            comment: row['comment'] as String,
            ownerName: row['ownerName'] as String,
            ownerPhotoUrl: row['ownerPhotoUrl'] as String?));
  }

  @override
  Future<void> updateCommentsOwnerName(
    String newOwnerName,
    String ownerId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'Update CommentModel Set ownerName = ?1 Where ownerId = ?2',
        arguments: [newOwnerName, ownerId]);
  }

  @override
  Future<void> insertComment(CommentModel model) async {
    await _commentModelInsertionAdapter.insert(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteComment(CommentModel model) async {
    await _commentModelDeletionAdapter.delete(model);
  }
}
