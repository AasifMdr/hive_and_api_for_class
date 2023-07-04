import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_and_api_for_class/features/batch/domain/entity/batch_entity.dart';
import 'package:hive_and_api_for_class/features/batch/domain/use_case/batch_use_case.dart';
import 'package:hive_and_api_for_class/features/batch/presentation/viewmodel/batch_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/batch_entity_test.dart';

@GenerateNiceMocks([
  MockSpec<BatchUseCase>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late BatchUseCase mockBatchUsecase;
  late ProviderContainer container;
  late List<BatchEntity> batchEntity;

  setUpAll(() async {
    mockBatchUsecase = mockBatchUsecase;
    batchEntity = await getBatchListTest();

    when(mockBatchUsecase.getAllBatches())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        batchViewModelProvider.overrideWith(
          (ref) => BatchViewModel(mockBatchUsecase),
        ),
      ],
    );
  });

  test('check for the list of batches when calling getAllBatches', () async {
    when(mockBatchUsecase.getAllBatches())
        .thenAnswer((_) => Future.value(Right(batchEntity)));

    await container.read(batchViewModelProvider.notifier).getAllBatches();

    final batchState = container.read(batchViewModelProvider);

    expect(batchState.isLoading, false);
    expect(batchState.batches.length, 4);
  });
}
