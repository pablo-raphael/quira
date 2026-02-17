import 'package:get_it/get_it.dart';
import 'package:quira/layers/data/datasources/quiz_catalog_data_source.dart';
import 'package:quira/layers/data/datasources/quiz_history_data_source.dart';
import 'package:quira/layers/data/repositories/quiz_repository_impl.dart';
import 'package:quira/layers/domain/repositories/quiz_repository.dart';
import 'package:quira/layers/domain/usecases/delete_attempt_by_quiz_id_usecase.dart';
import 'package:quira/layers/domain/usecases/get_all_attempts_usecase.dart';
import 'package:quira/layers/domain/usecases/get_all_quizzes_usecase.dart';
import 'package:quira/layers/domain/usecases/save_attempt_usecase.dart';
import 'package:quira/layers/presentation/controllers/home_controller.dart';

class Inject {
  Inject._();

  static void init() {
    final getIt = GetIt.instance;

    getIt.registerLazySingleton<QuizHistoryDataSource>(
      () => QuizHistoryDataSource(),
    );
    getIt.registerLazySingleton<QuizCatalogDataSource>(
      () => QuizCatalogDataSource(),
    );

    getIt.registerLazySingleton<QuizRepository>(
      () => QuizRepositoryImpl(
        quizHistoryDataSource: getIt(),
        quizCatalogDataSource: getIt(),
      ),
    );

    getIt.registerLazySingleton<GetAllQuizzesUseCase>(
      () => GetAllQuizzesUseCase(getIt()),
    );
    getIt.registerLazySingleton<GetAllAttemptsUseCase>(
      () => GetAllAttemptsUseCase(getIt()),
    );
    getIt.registerLazySingleton<SaveAttemptUseCase>(
      () => SaveAttemptUseCase(getIt()),
    );
    getIt.registerLazySingleton<DeleteAttemptByQuizIdUseCase>(
      () => DeleteAttemptByQuizIdUseCase(getIt()),
    );

    getIt.registerLazySingleton<HomeController>(
      () => HomeController(getIt(), getIt(), getIt()),
    );
  }
}
