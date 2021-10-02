import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/src/repositories/memory_repository.dart';
import 'package:widgetbook/src/models/model.dart';

class _Item extends Model {
  final int value;
  _Item({
    required String id,
    required this.value,
  }) : super(
          id: id,
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _Item && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _MemoryRepository extends MemoryRepository<_Item> {
  _MemoryRepository({Map<String, _Item>? initialConfiguration})
      : super(
          initialConfiguration: initialConfiguration,
        );

  Map<String, _Item> getMemory() {
    return memory;
  }
}

void main() {
  String defaultId = '1';
  String alternateId = '2';

  group(
    '$MemoryRepository',
    () {
      test(
        'adds item when addItem is called',
        () async {
          var repository = _MemoryRepository();
          var stream = repository.getStreamOfItems();

          expect(
            stream,
            emitsInOrder(
              [
                <_Item>[],
                <_Item>[
                  _Item(
                    id: defaultId,
                    value: 0,
                  ),
                ],
                emitsDone,
              ],
            ),
          );

          repository.addItem(
            _Item(
              id: defaultId,
              value: 0,
            ),
          );
          repository.closeStream();

          expect(
            repository.memory,
            equals(
              <String, _Item>{
                defaultId: _Item(
                  id: defaultId,
                  value: 0,
                ),
              },
            ),
          );
        },
      );

      test(
        'removes item when deleteItem is called',
        () async {
          var repository = _MemoryRepository(
            initialConfiguration: <String, _Item>{
              defaultId: _Item(
                id: defaultId,
                value: 0,
              ),
            },
          );
          var stream = repository.getStreamOfItems();

          expect(
            stream,
            emitsInOrder(
              [
                <_Item>[
                  _Item(
                    id: defaultId,
                    value: 0,
                  ),
                ],
                <_Item>[],
                emitsDone,
              ],
            ),
          );

          repository.deleteItem(
            _Item(
              id: defaultId,
              value: 0,
            ),
          );
          repository.closeStream();

          expect(
            repository.memory,
            equals(
              <String, _Item>{},
            ),
          );
        },
      );

      test(
        'changes existing item when setItem is called',
        () async {
          var repository = _MemoryRepository(
            initialConfiguration: <String, _Item>{
              defaultId: _Item(
                id: defaultId,
                value: 0,
              ),
            },
          );
          var stream = repository.getStreamOfItems();

          expect(
            stream,
            emitsInOrder(
              [
                <_Item>[
                  _Item(
                    id: defaultId,
                    value: 0,
                  ),
                ],
                <_Item>[
                  _Item(
                    id: defaultId,
                    value: 1,
                  ),
                ],
                emitsDone,
              ],
            ),
          );

          repository.setItem(
            _Item(
              id: defaultId,
              value: 1,
            ),
          );
          repository.closeStream();

          expect(
            repository.memory,
            equals(
              <String, _Item>{
                defaultId: _Item(
                  id: defaultId,
                  value: 1,
                ),
              },
            ),
          );
        },
      );

      test(
        'adds item when setItem is called',
        () async {
          var repository = _MemoryRepository();
          var stream = repository.getStreamOfItems();

          expect(
            stream,
            emitsInOrder(
              [
                <_Item>[],
                <_Item>[
                  _Item(
                    id: defaultId,
                    value: 0,
                  ),
                ],
                emitsDone,
              ],
            ),
          );

          repository.setItem(
            _Item(
              id: defaultId,
              value: 0,
            ),
          );
          repository.closeStream();

          expect(
            repository.memory,
            equals(
              <String, _Item>{
                defaultId: _Item(
                  id: defaultId,
                  value: 0,
                ),
              },
            ),
          );
        },
      );

      test(
        'returns true when doesItemExist is called with item in memory',
        () async {
          var repository = _MemoryRepository(
            initialConfiguration: <String, _Item>{
              defaultId: _Item(
                id: defaultId,
                value: 0,
              ),
            },
          );

          var result = repository.doesItemExist(defaultId);
          expect(
            result,
            isTrue,
          );
        },
      );

      test(
        'returns false when doesItemExist is called with item not in memory',
        () async {
          var repository = _MemoryRepository();

          var result = repository.doesItemExist(defaultId);
          expect(
            result,
            false,
          );
        },
      );

      test(
        'returns item when getItem is called',
        () async {
          var repository = _MemoryRepository(
            initialConfiguration: <String, _Item>{
              defaultId: _Item(
                id: defaultId,
                value: 0,
              ),
            },
          );

          var result = repository.getItem(defaultId);
          expect(
            result,
            equals(
              _Item(
                id: defaultId,
                value: 0,
              ),
            ),
          );
        },
      );

      test(
        'removes all items when deleteAll is called',
        () async {
          var repository = _MemoryRepository(
            initialConfiguration: <String, _Item>{
              defaultId: _Item(
                id: defaultId,
                value: 0,
              ),
              alternateId: _Item(
                id: alternateId,
                value: 1,
              ),
            },
          );
          var stream = repository.getStreamOfItems();

          expect(
            stream,
            emitsInOrder(
              [
                <_Item>[
                  _Item(
                    id: defaultId,
                    value: 0,
                  ),
                  _Item(
                    id: alternateId,
                    value: 1,
                  ),
                ],
                <_Item>[],
                emitsDone,
              ],
            ),
          );

          repository.deleteAll();
          repository.closeStream();

          expect(
            repository.memory,
            equals(
              <String, _Item>{},
            ),
          );
        },
      );

      test(
        'removes all items when deleteAll is called',
        () async {
          var repository = _MemoryRepository();
          var stream = repository.getStreamOfItems();

          expect(
            stream,
            emitsInOrder(
              [
                <_Item>[],
                <_Item>[
                  _Item(
                    id: defaultId,
                    value: 0,
                  ),
                  _Item(
                    id: alternateId,
                    value: 1,
                  ),
                ],
                emitsDone,
              ],
            ),
          );

          repository.addAll([
            _Item(
              id: defaultId,
              value: 0,
            ),
            _Item(
              id: alternateId,
              value: 1,
            ),
          ]);
          repository.closeStream();

          expect(
            repository.memory,
            equals(
              <String, _Item>{
                defaultId: _Item(
                  id: defaultId,
                  value: 0,
                ),
                alternateId: _Item(
                  id: alternateId,
                  value: 1,
                ),
              },
            ),
          );
        },
      );
    },
  );
}
