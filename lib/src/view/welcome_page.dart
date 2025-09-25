import 'package:task_management/core/utils/toast.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/home/home_bloc.dart';
import 'package:task_management/src/logic/home/home_state.dart';
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
        print('------------------------');
        print(state);
        print('------------------------');
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
                      const SizedBox(height: 8),

                      // Azkar Cards
                      // _buildAzkarCard(
                      //   title: 'أذكار الصباح',
                      //   subtitle: 'بعد صلاة الفجر حتى شروق الشمس',
                      //   image: 'assets/images/morning.png',
                      //   icon: Icons.wb_sunny,
                      //   onTap: () => _navigateToAzkar(AzkarType.morning),
                      // ),

                      // const SizedBox(height: 16),

                      // _buildAzkarCard(
                      //   title: 'أذكار المساء',
                      //   subtitle: 'بعد صلاة العصر حتى غروب الشمس',
                      //   image: 'assets/images/evening.png',
                      //   icon: Icons.nights_stay,
                      //   onTap: () => _navigateToAzkar(AzkarType.evening),
                      // ),

                      // const SizedBox(height: 16),

                      // _buildAzkarCard(
                      //   title: 'أذكار عامة',
                      //   subtitle: 'أدعية وأذكار متنوعة لكل وقت',
                      //   image: 'assets/images/general.png',
                      //   icon: Icons.menu_book,
                      //   onTap: () => _navigateToAzkar(AzkarType.general),
                      // ),
                      const SizedBox(height: 32),

                      /* // Stats Section
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
                        */
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        /*   // Bottom Navigation
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AzkarTheme.cardColor,
              border: Border(
                top: BorderSide(color: AzkarTheme.outlineColor, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavItem(
                      icon: Icons.home,
                      label: 'الرئيسية',
                      isActive: true,
                      onTap: () {},
                    ),
                    _buildBottomNavItem(
                      icon: Icons.bookmark_outline,
                      label: 'المفضلة',
                      isActive: false,
                      onTap: () {},
                    ),
                    _buildBottomNavItem(
                      icon: Icons.settings_outlined,
                      label: 'الإعدادات',
                      isActive: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ), */
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

  Widget _buildAzkarCard({
    required String title,
    required String subtitle,
    required String image,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
            ),
            // Icon
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
            ),
            // Text content
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AzkarTheme.primaryColor
                  : AzkarTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AzkarTheme.primaryColor
                    : AzkarTheme.textSecondary,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _navigateToAzkar(AzkarType type) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => AzkarScreen(key: Key(type.name), type: type),
  //     ),
  //   );
  // }

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
