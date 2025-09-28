import 'package:task_management/core/utils/toast.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/repositories/task_repository.dart';
import 'package:task_management/src/view/widgets/dimond_background.dart';
import 'package:flutter/material.dart';
import 'package:task_management/core/cache/app_cache.dart';
import 'package:task_management/core/theme/azkar_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const int _dailyAdLimit = 30;
  int _remainingAdsToday = 30;

  bool loadingAd = false;

  TasksBloc bloc = TasksBloc(taskRepository: sl<TaskRepository>());

  @override
  void initState() {
    super.initState();
    bloc.add(LoadTasks());
    _refreshRemaining();
  }

  void _refreshRemaining() {
    try {
      _remainingAdsToday = AppCache.instance.getRemainingAdsToday(
        _dailyAdLimit,
      );
      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksBloc, TasksState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is TasksError) {
          Toast.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AzkarTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              'أذكاري حيالتي',
              style: TextStyle(
                color: AzkarTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.search, color: AzkarTheme.textPrimary),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.dark_mode_outlined,
                color: AzkarTheme.textPrimary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              const Positioned.fill(child: DiamondBackground()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // Stats Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AzkarTheme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'إحصائيات',
                              style: TextStyle(
                                color: AzkarTheme.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  '${AppCache.instance.getTimesPlayed()}',
                                  'مرات القراءة',
                                ),
                                _buildStatItem(
                                  "${AppCache.instance.getAdPoints()}",
                                  'النقاط',
                                ),
                                _buildStatItem(
                                  '$_remainingAdsToday',
                                  'إعلانات اليوم',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AzkarTheme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AzkarTheme.textSecondary, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<dynamic> showAboutOusDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('من نحن؟'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "شركة إيكونوميكس - ECONOMIX",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "منصة سورية مبتكرة تهدف إلى توفير فرص عمل حقيقية عبر الإنترنت، بما يتناسب مع ظروف الشباب السوري داخل البلاد.",
            ),
            const SizedBox(height: 16),
            Text(
              "🎯 ماذا نقدم؟  ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "- وظائف عن بعد في مجالات متنوعة (تسويق، إدخال بيانات، تصميم، دعم فني...)",
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('حسنا'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
