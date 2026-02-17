import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/core/theme/app_styles.dart';
import 'package:quira/core/theme/app_tokens.dart';
import 'package:quira/core/theme/app_theme.dart';
import 'package:quira/l10n/app_localizations.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_answer_entity.dart';
import 'package:quira/layers/domain/entities/catalog/alternative_entity.dart';
import 'package:quira/layers/domain/entities/catalog/question_entity.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';
import 'package:quira/layers/presentation/controllers/home_controller.dart';
import 'package:quira/layers/presentation/extensions/quira_error_localization_extension.dart';
import 'package:quira/layers/presentation/pages/quiz_page.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.quiz});

  final QuizEntity quiz;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  bool _isRestarting = false;

  @override
  Widget build(BuildContext context) {
    final answers = _homeController.answersForQuiz(widget.quiz.id);
    final correctAnswers = _homeController.countCorrectAnswers(
      quiz: widget.quiz,
      answers: answers,
    );
    final totalQuestions = widget.quiz.questions.length;
    final resultPercent = totalQuestions == 0
        ? 0.0
        : (correctAnswers / totalQuestions).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title, overflow: TextOverflow.ellipsis),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ResultSummaryCard(
              correctAnswers: correctAnswers,
              totalQuestions: totalQuestions,
              percent: resultPercent,
            ),
          ),
          if (widget.quiz.questions.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      AppLocalizations.of(context)!.resultNoQuestions,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            sliver: SliverList.separated(
              itemCount: widget.quiz.questions.length,
              itemBuilder: (context, index) {
                final question = widget.quiz.questions[index];
                final selectedAnswer = _findSelectedAlternative(
                  answers: answers,
                  question: question,
                );

                return _CorrectionCard(
                  questionNumber: index + 1,
                  question: question,
                  selectedAnswer: selectedAnswer,
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomActionBar(
        isLoading: _isRestarting,
        onPressed: _isRestarting ? null : _onRestartPressed,
      ),
    );
  }

  AlternativeEntity? _findSelectedAlternative({
    required List<QuizAnswerEntity> answers,
    required QuestionEntity question,
  }) {
    final answer = answers.where((item) {
      return item.questionId == question.id;
    }).firstOrNull;
    if (answer == null) {
      return null;
    }

    return question.alternatives.where((alternative) {
      return alternative.id == answer.selectedAlternativeId;
    }).firstOrNull;
  }

  Future<void> _onRestartPressed() async {
    setState(() {
      _isRestarting = true;
    });

    try {
      await _homeController.restartQuiz(widget.quiz.id);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => QuizPage(quiz: widget.quiz)),
      );
    } on QuiraException catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(error.cause.localizedText(context));
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnackBar(QuiraError.unknown.localizedText(context));
    } finally {
      if (mounted) {
        setState(() {
          _isRestarting = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ResultSummaryCard extends StatelessWidget {
  const _ResultSummaryCard({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.percent,
  });

  final int correctAnswers;
  final int totalQuestions;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: AppSizes.progressRadius,
                lineWidth: AppSizes.progressStroke,
                percent: percent,
                center: Text(
                  '${(percent * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: AppFontSizes.body,
                  ),
                ),
                progressColor: percent >= 0.7
                    ? Colors.green
                    : (percent >= 0.4 ? Colors.amber.shade700 : Colors.red),
                backgroundColor: AppTheme.brand.withValues(alpha: 0.1),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.resultCompletedTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      l10n.resultCorrectCount(correctAnswers, totalQuestions),
                      style: const TextStyle(color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  const _CorrectionCard({
    required this.questionNumber,
    required this.question,
    required this.selectedAnswer,
  });

  final int questionNumber;
  final QuestionEntity question;
  final AlternativeEntity? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final correctAlternative = question.alternatives.where((alternative) {
      return alternative.id == question.correctAlternativeId;
    }).firstOrNull;

    final isCorrect =
        selectedAnswer != null &&
        correctAlternative != null &&
        selectedAnswer!.id == correctAlternative.id;
    final isUnanswered = selectedAnswer == null;
    final shouldShowCorrectAnswerBlock = !isCorrect;

    final statusColor = isUnanswered
        ? AppTheme.muted
        : (isCorrect ? Colors.green : Colors.red);
    final statusText = isUnanswered
        ? l10n.resultStatusUnanswered
        : (isCorrect ? l10n.resultStatusCorrect : l10n.resultStatusIncorrect);
    final statusIcon = isUnanswered
        ? Icons.remove_circle_outline_rounded
        : (isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.resultQuestionTitle(questionNumber, question.prompt),
                    style: AppStyles.title,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                _StatusBadge(
                  text: statusText,
                  icon: statusIcon,
                  color: statusColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _AnswerBlock(
              label: l10n.resultYourAnswerLabel,
              value: selectedAnswer?.text ?? l10n.resultNotAnswered,
              tint: isCorrect
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.blueGrey.withValues(alpha: 0.08),
            ),
            if (shouldShowCorrectAnswerBlock) ...[
              const SizedBox(height: AppSpacing.xs),
              _AnswerBlock(
                label: l10n.resultCorrectAnswerLabel,
                value: correctAlternative?.text ?? l10n.resultUnavailable,
                tint: Colors.green.withValues(alpha: 0.12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: AppSizes.statusIcon),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _AnswerBlock extends StatelessWidget {
  const _AnswerBlock({
    required this.label,
    required this.value,
    required this.tint,
  });

  final String label;
  final String value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppStyles.answerLabel),
          const SizedBox(height: AppSpacing.xxs),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding =
        MediaQuery.viewPaddingOf(context).bottom +
        AppSpacing.actionBarBottomSafeExtra;

    return Material(
      color: Colors.white,
      elevation: AppElevation.actionBar,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          bottomPadding,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(isLoading ? l10n.resultRestarting : l10n.resultRedoQuiz),
        ),
      ),
    );
  }
}
