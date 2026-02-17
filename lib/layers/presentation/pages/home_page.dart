import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/language/app_language.dart';
import 'package:quira/core/theme/app_styles.dart';
import 'package:quira/core/theme/app_theme.dart';
import 'package:quira/core/theme/app_tokens.dart';
import 'package:quira/l10n/app_localizations.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';
import 'package:quira/layers/presentation/controllers/home_controller.dart';
import 'package:quira/layers/presentation/extensions/quira_error_localization_extension.dart';
import 'package:quira/layers/presentation/pages/quiz_page.dart';
import 'package:quira/layers/presentation/pages/result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  AppLanguage _currentLanguage = AppLanguage.en;
  bool _didLoadOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final language = AppLanguage.fromLocale(Localizations.localeOf(context));
    if (_didLoadOnce && _currentLanguage == language) {
      return;
    }

    _didLoadOnce = true;
    _currentLanguage = language;
    _homeController.load(_currentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[AppTheme.brandDark, AppTheme.brand],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _homeController,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.homeTagline,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _HeaderMetric(
                          totalQuizzes: _homeController.quizzes.length,
                          completedQuizzes: _homeController.quizzes.where((
                            quiz,
                          ) {
                            return _homeController.isQuizAnswered(quiz.id);
                          }).length,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.topSection),
                          topRight: Radius.circular(AppRadius.topSection),
                        ),
                      ),
                      child: _buildBody(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (_homeController.status) {
      case HomeLoadStatus.initial:
      case HomeLoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case HomeLoadStatus.error:
        return _StateCard(
          title: l10n.homeLoadErrorTitle,
          message:
              _homeController.error?.localizedText(context) ??
              QuiraError.unknown.localizedText(context),
          buttonLabel: l10n.homeTryAgain,
          onPressed: () => _homeController.load(_currentLanguage),
        );
      case HomeLoadStatus.loaded:
        if (_homeController.quizzes.isEmpty) {
          return _StateCard(
            title: l10n.homeNoQuizzesTitle,
            message: l10n.homeNoQuizzesMessage,
            buttonLabel: l10n.homeRefresh,
            onPressed: () => _homeController.load(_currentLanguage),
          );
        }
        return RefreshIndicator(
          onRefresh: () => _homeController.load(_currentLanguage),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            itemCount: _homeController.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = _homeController.quizzes[index];
              final isAnswered = _homeController.isQuizAnswered(quiz.id);
              return _QuizCard(
                quiz: quiz,
                isAnswered: isAnswered,
                onTap: () {
                  final page = isAnswered
                      ? ResultPage(quiz: quiz)
                      : QuizPage(quiz: quiz);
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => page));
                },
              );
            },
          ),
        );
    }
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.totalQuizzes,
    required this.completedQuizzes,
  });

  final int totalQuizzes;
  final int completedQuizzes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: AppSizes.headerMetricIcon,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            l10n.homeCompletedMetric(completedQuizzes, totalQuizzes),
            style: AppStyles.whiteSemiBold,
          ),
        ],
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(onPressed: onPressed, child: Text(buttonLabel)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({
    required this.quiz,
    required this.isAnswered,
    required this.onTap,
  });

  final QuizEntity quiz;
  final bool isAnswered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.quizCardIcon,
                height: AppSizes.quizCardIcon,
                decoration: BoxDecoration(
                  color: isAnswered
                      ? Colors.green.withValues(alpha: 0.16)
                      : AppTheme.brand.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  isAnswered ? Icons.check_rounded : Icons.bolt_rounded,
                  color: isAnswered ? Colors.green : AppTheme.brandDark,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.title,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      isAnswered
                          ? l10n.homeTapToReviewAnswers
                          : l10n.homeTapToStartQuiz,
                      style: AppStyles.mutedSmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
