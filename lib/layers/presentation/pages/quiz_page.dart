import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/core/theme/app_tokens.dart';
import 'package:quira/core/theme/app_theme.dart';
import 'package:quira/l10n/app_localizations.dart';
import 'package:quira/layers/domain/entities/catalog/alternative_entity.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';
import 'package:quira/layers/presentation/controllers/home_controller.dart';
import 'package:quira/layers/presentation/controllers/quiz_session_controller.dart';
import 'package:quira/layers/presentation/extensions/quira_error_localization_extension.dart';
import 'package:quira/layers/presentation/pages/result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.quiz});

  final QuizEntity quiz;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late final QuizSessionController _sessionController;
  final HomeController _homeController = GetIt.I.get<HomeController>();

  @override
  void initState() {
    super.initState();
    _sessionController = QuizSessionController(
      saveAttemptUseCase: GetIt.I.get(),
      quiz: widget.quiz,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: _sessionController,
      builder: (context, _) {
        final question = _sessionController.currentQuestion;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.quiz.title, overflow: TextOverflow.ellipsis),
          ),
          body: _sessionController.hasQuestions
              ? CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _QuestionIndexBar(
                        currentQuestionIndex:
                            _sessionController.currentQuestionIndex,
                        totalQuestions: _sessionController.totalQuestions,
                        onJumpToQuestion: _sessionController.jumpToQuestion,
                      ),
                    ),
                    if (question != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.xs,
                          ),
                          child: Text(
                            question.prompt,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    if (question != null)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.xxs,
                          AppSpacing.md,
                          AppSpacing.md,
                        ),
                        sliver: SliverList.separated(
                          itemCount: question.alternatives.length,
                          itemBuilder: (context, index) {
                            final alternative = question.alternatives[index];
                            final currentSelection = _sessionController
                                .selectedAlternativeForQuestion(question.id);
                            return _AlternativeOption(
                              alternative: alternative,
                              isSelected:
                                  currentSelection?.id == alternative.id,
                              onTap: () {
                                _sessionController.selectAlternative(
                                  alternative,
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.xs),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.quizBottomSpacer),
                    ),
                  ],
                )
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: _EmptyQuizText(),
                  ),
                ),
          bottomNavigationBar: _BottomActionBar(
            enabled:
                _sessionController.hasQuestions && !_sessionController.isSaving,
            label: _sessionController.isSaving
                ? l10n.quizSaving
                : (_sessionController.isLastQuestion
                      ? l10n.quizFinish
                      : l10n.quizNextQuestion),
            onPressed:
                _sessionController.hasQuestions && !_sessionController.isSaving
                ? () => _onConfirmPressed(context)
                : null,
          ),
        );
      },
    );
  }

  Future<void> _onConfirmPressed(BuildContext context) async {
    if (!_sessionController.isLastQuestion) {
      _sessionController.goToNextQuestion();
      return;
    }

    if (!_sessionController.hasAllQuestionsAnswered) {
      final l10n = AppLocalizations.of(context)!;

      AwesomeDialog(
        context: context,
        title: l10n.quizIncompleteTitle,
        desc: l10n.quizIncompleteMessage,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        showCloseIcon: true,
      ).show();
      return;
    }

    try {
      await _sessionController.finishQuiz();
      await _homeController.refreshAttempts();

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ResultPage(quiz: widget.quiz)),
      );
    } on QuiraException catch (error) {
      if (!context.mounted) {
        return;
      }
      _showSnackBar(context, error.cause.localizedText(context));
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      _showSnackBar(context, QuiraError.unknown.localizedText(context));
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _QuestionIndexBar extends StatelessWidget {
  const _QuestionIndexBar({
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onJumpToQuestion,
  });

  final int currentQuestionIndex;
  final int totalQuestions;
  final ValueChanged<int> onJumpToQuestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(totalQuestions, (index) {
            final isCurrent = currentQuestionIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: ChoiceChip(
                label: Text((index + 1).toString()),
                selected: isCurrent,
                showCheckmark: false,
                onSelected: (_) => onJumpToQuestion(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _AlternativeOption extends StatelessWidget {
  const _AlternativeOption({
    required this.alternative,
    required this.isSelected,
    required this.onTap,
  });

  final AlternativeEntity alternative;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isSelected ? AppTheme.brand : const Color(0xFFE5E7EB),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppTheme.brand : AppTheme.muted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  alternative.text,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.enabled,
    required this.label,
    required this.onPressed,
  });

  final bool enabled;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
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
          onPressed: enabled ? onPressed : null,
          child: Text(label),
        ),
      ),
    );
  }
}

class _EmptyQuizText extends StatelessWidget {
  const _EmptyQuizText();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Text(l10n.quizNoQuestions, textAlign: TextAlign.center);
  }
}
