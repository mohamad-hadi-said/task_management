import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management/core/utils/toast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String selectedLanguage = "العربية";
  String selectedTheme = "داكن";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Header Card
          _buildHeaderCard(),

          const SizedBox(height: 20),

          // Section 1: General
          _buildSectionTitle("عام", Icons.tune_rounded),
          const SizedBox(height: 8),
          _buildCardGroup([
            _buildSettingTile(
              icon: Icons.language_rounded,
              iconColor: const Color(0xFF4A90E2),
              title: "لغة التطبيق",
              subtitle: "تغيير لغة الواجهة والعرض",
              trailing: _buildValueBadge(selectedLanguage),
              onTap: _showLanguageSelectionModal,
            ),
          ]),

          const SizedBox(height: 20),

          // Section 2: Preferences
          _buildSectionTitle(
            "التفضيلات والأنشطة",
            Icons.notifications_none_rounded,
          ),
          const SizedBox(height: 8),
          _buildCardGroup([
            _buildSettingTile(
              icon: Icons.notifications_active_rounded,
              iconColor: const Color(0xFFF39C12),
              title: "التحكم في الإشعارات",
              subtitle: "تلقي تنبيهات المواعيد والمهام",
              trailing: Switch.adaptive(
                value: notificationsEnabled,
                activeThumbColor: const Color(0xFF4A90E2),
                activeTrackColor: const Color(
                  0xFF4A90E2,
                ).withValues(alpha: 0.4),
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ),
          ]),

          const SizedBox(height: 20),

          // Section 3: Theme / Appearance
          _buildSectionTitle("المظهر والمواضيع", Icons.palette_outlined),
          const SizedBox(height: 8),
          _buildCardGroup([
            _buildSettingTile(
              icon: Icons.dark_mode_rounded,
              iconColor: const Color(0xFF9B59B6),
              title: "ثيم التطبيق",
              subtitle: "اختر النمط البصري المفضل لديك",
              trailing: _buildValueBadge(selectedTheme),
              onTap: _showThemeSelectionModal,
            ),
          ]),

          const SizedBox(height: 20),

          // Section 4: About
          _buildSectionTitle("معلومات التطبيق", Icons.info_outline_rounded),
          const SizedBox(height: 8),
          _buildCardGroup([
            _buildSettingTile(
              icon: Icons.verified_user_rounded,
              iconColor: const Color(0xFF27AE60),
              title: "إصدار التطبيق",
              subtitle: "إصدار 1.0.0 (محدث لآخر نسخة)",
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF27AE60).withValues(alpha: 0.4),
                  ),
                ),
                child: const Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Color(0xFF27AE60),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: _showDeveloperInfoDialog,
            ),
          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Header Profile / Overview Card
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2A2D3E), const Color(0xFF1E2132)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "إعدادات التطبيق",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "تخصص مظهر التطبيق والإشعارات والخيارات العامة",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header Title
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4A90E2)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  /// Wrapper container for grouped settings tiles
  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  /// Single Setting Tile
  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: iconColor.withValues(alpha: 0.1),
        highlightColor: iconColor.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  /// Badge displaying current selection with arrow indicator
  Widget _buildValueBadge(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF4A90E2),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  /// Modern Language Selection Dialog
  void _showLanguageSelectionModal() {
    _showSelectionModal(
      title: "اختر لغة التطبيق",
      icon: Icons.language_rounded,
      options: ["العربية", "English"],
      selectedValue: selectedLanguage,
      onSelect: (val) {
        setState(() {
          selectedLanguage = val;
        });
      },
    );
  }

  /// Modern Theme Selection Dialog
  void _showThemeSelectionModal() {
    _showSelectionModal(
      title: "اختر ثيم التطبيق",
      icon: Icons.palette_rounded,
      options: ["داكن", "فاتح"],
      selectedValue: selectedTheme,
      onSelect: (val) {
        setState(() {
          selectedTheme = val;
        });
      },
    );
  }

  /// Reusable Option Selector Dialog
  void _showSelectionModal({
    required String title,
    required IconData icon,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelect,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: const Color(0xFF2A2D3E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.white12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF4A90E2,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: const Color(0xFF4A90E2),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 12),
                  ...options.map((option) {
                    final isSelected = selectedValue == option;
                    return GestureDetector(
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4A90E2).withValues(alpha: 0.15)
                              : const Color(0xFF1A1D2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4A90E2)
                                : Colors.white12,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[300],
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF4A90E2),
                                size: 20,
                              )
                            else
                              Icon(
                                Icons.radio_button_off_rounded,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Developer Info Dialog
  void _showDeveloperInfoDialog() {
    const linkedInUrl = "https://sy.linkedin.com/in/mohamad-hadi-said";

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: const Color(0xFF2A2D3E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.white12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon & Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF0A66C2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0A66C2).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.engineering_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "مطور التطبيق",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 16),

                  // Developer Message
                  const Text(
                    "تم تصميم هذا التطبيق من قبل المهندس محمد هادي سعيد",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LinkedIn Card / Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(
                          const ClipboardData(text: linkedInUrl),
                        );
                        Toast.success(context, "تم نسخ رابط LinkedIn بنجاح!");
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D2E),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(
                              0xFF0A66C2,
                            ).withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF0A66C2,
                                ).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.link_rounded,
                                color: Color(0xFF0A66C2),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "حساب LinkedIn",
                                    style: TextStyle(
                                      color: Color(0xFF0A66C2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    linkedInUrl,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.copy_rounded,
                              color: Colors.white54,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "إغلاق",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
