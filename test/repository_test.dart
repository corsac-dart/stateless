library corsac_dal.tests.repository;

import 'package:corsac_dal/corsac_dal.dart';
import 'package:test/test.dart';

void main() {
  group('In-memory Repository:', () {
    InMemoryRepository<User> repo;

    setUp(() async {
      repo = new InMemoryRepository<User>();
      await repo.put(new User(1, 'Deadpool'));
      await repo.put(new User(2, 'Ron Swanson'));
      await repo.put(new User(3, 'Johnny Karate'));
    });

    test('it stores entities', () async {
      var user = new User(341, 'Burt Macklin');
      var repository = new InMemoryRepository();
      repository.put(user);
      var fetchedUser = await repository.get(341);
      expect(fetchedUser, same(user));
      var noSuchUser = await repository.get(12836);
      expect(noSuchUser, isNull);
    });

    test('it can filter entities with equals condition', () async {
      var filter = new Filter<User>();
      filter.where((u) => u.id == 1);
      var result = await repo.find(filter).toList();
      expect(result, hasLength(1));
      expect(result.first.id, equals(1));

      var user = await repo.findOne(filter);
      expect(user, new isInstanceOf<User>());
      expect(user.id, 1);
    });

    test('it returns null in findOne if entity not found', () async {
      var filter = new Filter<User>();
      filter.where((u) => u.id == 24353);
      var result = await repo.findOne(filter);
      expect(result, isNull);
    });
  });
}

class User {
  final int id;
  final String name;

  User(this.id, this.name);

  String toString() => "$id $name";
}
