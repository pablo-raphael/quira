import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_answer_entity.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';
import 'package:quira/layers/domain/entities/catalog/alternative_entity.dart';
import 'package:quira/layers/domain/entities/catalog/question_entity.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';
import 'package:quira/layers/domain/usecases/save_attempt_usecase.dart';

class QuizSessionController extends ChangeNotifier {
  final SaveAttemptUseCase _saveAttemptUseCase;
  final QuizEntity quiz;

  QuizSessionController({
    required SaveAttemptUseCase saveAttemptUseCase,
    required this.quiz,
  }) : _saveAttemptUseCase = saveAttemptUseCase;

  int _currentQuestionIndex = 0;
  bool _isSaving = false;
  final Map<int, int> _selectedAlternativeIdByQuestion = <int, int>{};

  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isSaving => _isSaving;
  bool get hasQuestions => quiz.questions.isNotEmpty;

  QuestionEntity? get currentQuestion {
    if (!hasQuestions) {
      return null;
    }
    return quiz.questions[_currentQuestionIndex];
  }

  bool get isLastQuestion {
    if (!hasQuestions) {
      return false;
    }
    return _currentQuestionIndex == quiz.questions.length - 1;
  }

  int get totalQuestions => quiz.questions.length;
  bool get hasAllQuestionsAnswered {
    return _selectedAlternativeIdByQuestion.length == quiz.questions.length;
  }

  UnmodifiableListView<QuizAnswerEntity> get answers {
    final orderedAnswers = quiz.questions
        .map((question) {
          final selectedAlternativeId =
              _selectedAlternativeIdByQuestion[question.id];
          if (selectedAlternativeId == null) {
            return null;
          }
          return QuizAnswerEntity(
            questionId: question.id,
            selectedAlternativeId: selectedAlternativeId,
          );
        })
        .whereType<QuizAnswerEntity>()
        .toList();
    return UnmodifiableListView(orderedAnswers);
  }

  void jumpToQuestion(int index) {
    if (!hasQuestions || index < 0 || index >= quiz.questions.length) {
      return;
    }
    _currentQuestionIndex = index;
    notifyListeners();
  }

  bool goToNextQuestion() {
    if (!hasQuestions || isLastQuestion) {
      return false;
    }
    _currentQuestionIndex++;
    notifyListeners();
    return true;
  }

  void selectAlternative(AlternativeEntity alternative) {
    final question = currentQuestion;
    if (question == null) {
      return;
    }
    _selectedAlternativeIdByQuestion[question.id] = alternative.id;
    notifyListeners();
  }

  AlternativeEntity? selectedAlternativeForQuestion(int questionId) {
    final selectedId = _selectedAlternativeIdByQuestion[questionId];
    if (selectedId == null) {
      return null;
    }
    final question = quiz.questions.where((item) {
      return item.id == questionId;
    }).firstOrNull;
    if (question == null) {
      return null;
    }
    return question.alternatives.where((alternative) {
      return alternative.id == selectedId;
    }).firstOrNull;
  }

  Future<void> finishQuiz() async {
    if (_isSaving) {
      return;
    }

    if (!hasAllQuestionsAnswered) {
      throw const QuiraException(QuiraError.invalidParams);
    }

    final attempt = QuizAttemptEntity(quizId: quiz.id, answers: answers);

    _isSaving = true;
    notifyListeners();
    try {
      await _saveAttemptUseCase(attempt);
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
