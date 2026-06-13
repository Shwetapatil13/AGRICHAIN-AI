import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const AgriChainApp());

class AgriChainApp extends StatefulWidget {
  const AgriChainApp({super.key});
  @override
  State<AgriChainApp> createState() => _AgriChainAppState();
}

class _AgriChainAppState extends State<AgriChainApp> {
  ThemeMode themeMode = ThemeMode.light;
  void toggleTheme() => setState(
    () => themeMode = themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark,
  );

  @override
  Widget build(BuildContext context) {
    return AppScope(
      toggleTheme: toggleTheme,
      themeMode: themeMode,
      child: MaterialApp(
        title: 'AgriChain AI',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
    required super.child,
  });
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;
  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;
  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      themeMode != oldWidget.themeMode;
}

class AuthSession {
  AuthSession._();
  static final Set<UserRole> _signedInRoles = {};
  static bool isSignedIn(UserRole role) => _signedInRoles.contains(role);
  static void signIn(UserRole role) => _signedInRoles.add(role);
  static void signOut(UserRole role) => _signedInRoles.remove(role);
}

class AppTheme {
  static const green = Color(0xFF10B981);
  static const deepGreen = Color(0xFF064E3B);
  static const blue = Color(0xFF2563EB);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const heroGradient = LinearGradient(
    colors: [deepGreen, Color(0xFF0E8F66), blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData light() => _base(
    Brightness.light,
  ).copyWith(scaffoldBackgroundColor: const Color(0xFFF5FAF7));
  static ThemeData dark() => _base(
    Brightness.dark,
  ).copyWith(scaffoldBackgroundColor: const Color(0xFF07110E));
  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        indicatorColor: green.withOpacity(.15),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? Colors.white.withOpacity(.08)
            : Colors.white.withOpacity(.75),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(.55)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: green, width: 1.5),
        ),
      ),
    );
  }
}

enum UserRole { farmer, shopkeeper, trader, admin }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.farmer => 'Farmer',
    UserRole.shopkeeper => 'Shopkeeper',
    UserRole.trader => 'Trader',
    UserRole.admin => 'Admin',
  };
  IconData get icon => switch (this) {
    UserRole.farmer => Icons.agriculture_rounded,
    UserRole.shopkeeper => Icons.storefront_rounded,
    UserRole.trader => Icons.local_shipping_rounded,
    UserRole.admin => Icons.admin_panel_settings_rounded,
  };
}

class MarketPrice {
  const MarketPrice(this.crop, this.price, this.change, this.values);
  final String crop;
  final String price;
  final String change;
  final List<double> values;
}

class MarketMember {
  const MarketMember({
    required this.name,
    required this.type,
    required this.subtitle,
    required this.distance,
    required this.price,
    required this.rating,
    required this.verified,
    required this.aiScore,
    required this.icon,
    required this.color,
  });
  final String name;
  final String type;
  final String subtitle;
  final double distance;
  final String price;
  final double rating;
  final bool verified;
  final int aiScore;
  final IconData icon;
  final Color color;
}

class DummyApi {
  static const prices = [
    MarketPrice('Tomato', 'Rs 28.5/kg', '+12%', [18, 20, 22, 25, 28, 31]),
    MarketPrice('Onion', 'Rs 22/kg', '+6%', [15, 17, 16, 19, 21, 22]),
    MarketPrice('Potato', 'Rs 18/kg', '-2%', [20, 19, 19, 18, 18, 18]),
    MarketPrice('Wheat', 'Rs 24/kg', '+4%', [20, 21, 22, 23, 23, 24]),
    MarketPrice('Rice', 'Rs 34/kg', '+8%', [28, 29, 31, 32, 33, 34]),
    MarketPrice('Cotton', 'Rs 72/kg', '+10%', [55, 58, 62, 66, 70, 72]),
    MarketPrice('Sugarcane', 'Rs 3.8/kg', '+3%', [
      3.2,
      3.3,
      3.5,
      3.6,
      3.7,
      3.8,
    ]),
  ];
  static const members = [
    MarketMember(
      name: 'Ramesh Patil',
      type: 'Farmers',
      subtitle: 'Tomato - 1.8 tons',
      distance: 4.2,
      price: 'Rs 28.5/kg',
      rating: 4.8,
      verified: true,
      aiScore: 96,
      icon: Icons.agriculture_rounded,
      color: AppTheme.green,
    ),
    MarketMember(
      name: 'Krushi Seva Kendra',
      type: 'Shopkeepers',
      subtitle: 'Fertilizer and medicine',
      distance: 2.1,
      price: 'Best rates',
      rating: 4.7,
      verified: true,
      aiScore: 91,
      icon: Icons.storefront_rounded,
      color: AppTheme.blue,
    ),
    MarketMember(
      name: 'Nashik Fresh Traders',
      type: 'Traders',
      subtitle: 'Buying tomato',
      distance: 5.0,
      price: 'Rs 31/kg',
      rating: 4.9,
      verified: true,
      aiScore: 98,
      icon: Icons.local_shipping_rounded,
      color: AppTheme.amber,
    ),
    MarketMember(
      name: 'Maharashtra Agro Mart',
      type: 'Traders',
      subtitle: 'Bulk vegetables',
      distance: 11.4,
      price: 'Premium',
      rating: 4.6,
      verified: true,
      aiScore: 89,
      icon: Icons.warehouse_rounded,
      color: Color(0xFF6366F1),
    ),
  ];
}

void go(BuildContext context, Widget page) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
void replace(BuildContext context, Widget page) =>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    Timer(const Duration(seconds: 3), () {
      if (mounted) replace(context, const OnboardingScreen());
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEFFFF7),
              Color(0xFFBDF7D6),
              AppTheme.green,
              AppTheme.deepGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: BackgroundPainter(light: true)),
            ),
            Center(
              child: AnimatedBuilder(
                animation: c,
                builder: (_, __) {
                  final pulse = 1 + sin(c.value * pi * 2) * .06;
                  return Transform.scale(
                    scale: pulse,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GlassLogo(size: 136),
                        const SizedBox(height: 30),
                        const Text(
                          'AgriChain AI',
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.deepGreen,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18),
                          child: Text(
                            'Empowering Agriculture with Generative & Agentic AI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.45,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.deepGreen,
                            ),
                          ),
                        ),
                        const CircularProgressIndicator(color: Colors.white),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pc = PageController();
  int index = 0;
  final pages = const [
    (
      'AI Assistant for Farmers',
      'Voice and text guidance for crops, disease, weather, prices and schemes.',
      Icons.support_agent_rounded,
      AppTheme.green,
    ),
    (
      'Direct Trading',
      'Connect Farmers, Shopkeepers and Traders directly with verified profiles and transparent prices.',
      Icons.handshake_rounded,
      AppTheme.blue,
    ),
    (
      'Smart Marketplace',
      'Generative and Agentic AI predicts prices, finds buyers and recommends the best selling time.',
      Icons.auto_awesome_rounded,
      AppTheme.amber,
    ),
  ];
  void next() => index == 2
      ? replace(context, const RoleSelectionScreen())
      : pc.nextPage(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
        );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.eco_rounded, color: AppTheme.deepGreen),
                  const SizedBox(width: 8),
                  const Text(
                    'AgriChain AI',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: AppTheme.deepGreen,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        replace(context, const RoleSelectionScreen()),
                    child: const Text('Skip'),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: pc,
                  itemCount: pages.length,
                  onPageChanged: (v) => setState(() => index = v),
                  itemBuilder: (_, i) {
                    final p = pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FloatingIllustration(icon: p.$3, color: p.$4),
                        ),
                        GlassCard(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: p.$4.withOpacity(.15),
                                child: Icon(p.$3, color: p.$4),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                p.$1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.deepGreen,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                p.$2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.4,
                                  color: AppTheme.deepGreen.withOpacity(.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    3,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 8),
                      width: i == index ? 30 : 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: i == index
                            ? AppTheme.green
                            : AppTheme.deepGreen.withOpacity(.18),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: next,
                    icon: Icon(
                      index == 2
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(index == 2 ? 'Start' : 'Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final roles = [
      (
        UserRole.farmer,
        'AI farming, disease detection, selling and marketplace.',
        const [AppTheme.deepGreen, AppTheme.green],
        const StakeholderLoginScreen(role: UserRole.farmer),
      ),
      (
        UserRole.shopkeeper,
        'License verification, stock demand and nearby farmers.',
        const [AppTheme.blue, Color(0xFF38BDF8)],
        const StakeholderLoginScreen(role: UserRole.shopkeeper),
      ),
      (
        UserRole.trader,
        'Bulk buying, transport, verified farmers and prices.',
        const [Color(0xFF0F766E), Color(0xFF14B8A6)],
        const StakeholderLoginScreen(role: UserRole.trader),
      ),
      (
        UserRole.admin,
        'Verification, moderation and analytics console.',
        const [Color(0xFF111827), Color(0xFF4B5563)],
        const StakeholderLoginScreen(role: UserRole.admin),
      ),
    ];
    return Scaffold(
      body: GradientBg(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 20),
            const Text(
              'Who are you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: AppTheme.deepGreen,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Choose your role to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.deepGreen.withOpacity(.68),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 26),
            for (var i = 0; i < roles.length; i++)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 420 + i * 90),
                builder: (_, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 24 * (1 - value)),
                    child: child,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: RoleCard(
                    role: roles[i].$1,
                    description: roles[i].$2,
                    colors: roles[i].$3,
                    onTap: () => go(context, roles[i].$4),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StakeholderLoginScreen extends StatefulWidget {
  const StakeholderLoginScreen({super.key, required this.role});
  final UserRole role;
  @override
  State<StakeholderLoginScreen> createState() => _StakeholderLoginScreenState();
}

class _StakeholderLoginScreenState extends State<StakeholderLoginScreen> {
  final formKey = GlobalKey<FormState>();
  final mobile = TextEditingController(), password = TextEditingController();
  bool obscure = true, profilePhoto = false, consent = true;

  @override
  void dispose() {
    mobile.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    if (!formKey.currentState!.validate()) return;
    if (!consent)
      return showInfo(
        context,
        'Permission Required',
        'Location and notification consent is required for stakeholder dashboards.',
      );
    showOtp(context, () {
      AuthSession.signIn(widget.role);
      replace(context, MainShell(role: widget.role));
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;
    final createPage = switch (role) {
      UserRole.farmer => const FarmerAuthScreen(),
      UserRole.shopkeeper => const ShopkeeperRegistrationScreen(),
      UserRole.trader => const TraderRegistrationScreen(),
      UserRole.admin => null,
    };
    return Scaffold(
      body: GradientBg(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              PageTop(
                title: '${role.label} Login',
                subtitle: 'Secure access is required for every dashboard',
                icon: role.icon,
              ),
              gap,
              PremiumGradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(role.icon, color: Colors.white, size: 54),
                    const SizedBox(height: 14),
                    Text(
                      '${role.label} control center',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'OTP login, profile photo proof and role-based access keep farmer, shopkeeper, trader and admin data separated.',
                      style: TextStyle(color: Colors.white70, height: 1.4),
                    ),
                  ],
                ),
              ),
              gap,
              GlassCard(
                child: Column(
                  children: [
                    PremiumField(
                      controller: mobile,
                      label: 'Mobile Number *',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: mobileValidator,
                    ),
                    gap,
                    PremiumField(
                      controller: password,
                      label: 'Password *',
                      icon: Icons.lock,
                      obscureText: obscure,
                      validator: passwordValidator,
                      suffix: IconButton(
                        onPressed: () => setState(() => obscure = !obscure),
                        icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    gap,
                    UploadBox(
                      title: profilePhoto
                          ? 'Profile Photo Uploaded'
                          : 'Upload Profile Photo',
                      active: profilePhoto,
                      icon: Icons.account_circle,
                      onTap: () => setState(() => profilePhoto = true),
                    ),
                    gap,
                    switchTile(
                      'Allow secure dashboard access',
                      'Used for OTP, nearby services and AI alerts.',
                      Icons.verified_user,
                      consent,
                      (v) => setState(() => consent = v),
                    ),
                    gap,
                    FilledButton.icon(
                      onPressed: profilePhoto ? login : null,
                      icon: const Icon(Icons.login),
                      label: Text('Login as ${role.label}'),
                    ),
                    if (createPage != null)
                      TextButton.icon(
                        onPressed: () => go(context, createPage),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Create verified account'),
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

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.role});
  final UserRole role;
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    if (!AuthSession.isSignedIn(widget.role)) {
      return StakeholderLoginScreen(role: widget.role);
    }
    final home = switch (widget.role) {
      UserRole.farmer => const FarmerDashboardScreen(),
      UserRole.shopkeeper => const ShopkeeperDashboardScreen(),
      UserRole.trader => const TraderDashboardScreen(),
      UserRole.admin => const AdminDashboardScreen(),
    };
    final pages = [
      home,
      const MarketplaceScreen(),
      const AiVoiceChatbotScreen(),
      const AiFarmManagerScreen(),
      ProfileSettingsScreen(role: widget.role),
    ];
    return Scaffold(
      drawer: AppDrawer(role: widget.role),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        child: pages[index],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.deepGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text('AI'),
        onPressed: () => showAiSheet(context),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (v) => setState(() => index = v),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront_rounded),
                label: 'Market',
              ),
              NavigationDestination(
                icon: Icon(Icons.mic_rounded),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Icons.sensors_rounded),
                label: 'Agent',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.role});
  final UserRole role;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 28, child: Icon(role.icon)),
                  const SizedBox(height: 16),
                  const Text(
                    'AgriChain AI',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  Text('${role.label} Console'),
                ],
              ),
            ),
            drawerTile(
              context,
              Icons.group_rounded,
              'Role Selection',
              const RoleSelectionScreen(),
              replacePage: true,
            ),
            drawerTile(
              context,
              Icons.agriculture_rounded,
              'Farmer Dashboard',
              const MainShell(role: UserRole.farmer),
              replacePage: true,
            ),
            drawerTile(
              context,
              Icons.store_rounded,
              'Shopkeeper Dashboard',
              const MainShell(role: UserRole.shopkeeper),
              replacePage: true,
            ),
            drawerTile(
              context,
              Icons.local_shipping_rounded,
              'Trader Dashboard',
              const MainShell(role: UserRole.trader),
              replacePage: true,
            ),
            drawerTile(
              context,
              Icons.mic_rounded,
              'AI Voice Chatbot',
              const AiVoiceChatbotScreen(),
            ),
            drawerTile(
              context,
              Icons.health_and_safety_rounded,
              'Disease Detection',
              const DiseaseDetectionScreen(),
            ),
            drawerTile(
              context,
              Icons.sell_rounded,
              'Sell Crop',
              const SellCropScreen(),
            ),
            drawerTile(
              context,
              Icons.storefront_rounded,
              'Smart Marketplace',
              const MarketplaceScreen(),
            ),
            drawerTile(
              context,
              Icons.sensors_rounded,
              'AI Farm Manager',
              const AiFarmManagerScreen(),
            ),
            drawerTile(
              context,
              Icons.store_mall_directory_rounded,
              'Shopkeeper Registration',
              const ShopkeeperRegistrationScreen(),
            ),
            drawerTile(
              context,
              Icons.badge_rounded,
              'Trader Registration',
              const TraderRegistrationScreen(),
            ),
            SwitchListTile(
              title: const Text('Dark mode'),
              value: AppScope.of(context).themeMode == ThemeMode.dark,
              onChanged: (_) => AppScope.of(context).toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerTile(
    BuildContext context,
    IconData icon,
    String title,
    Widget page, {
    bool replacePage = false,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        replacePage ? replace(context, page) : go(context, page);
      },
    );
  }
}

class FarmerAuthScreen extends StatefulWidget {
  const FarmerAuthScreen({super.key});
  @override
  State<FarmerAuthScreen> createState() => _FarmerAuthScreenState();
}

class _FarmerAuthScreenState extends State<FarmerAuthScreen> {
  final formKey = GlobalKey<FormState>();
  bool signup = true, gps = true, notifications = true, obscure = true;
  String lang = 'Marathi',
      state = 'Maharashtra',
      district = 'Pune',
      taluka = 'Haveli',
      unit = 'Acre';
  final name = TextEditingController(),
      email = TextEditingController(),
      mobile = TextEditingController(),
      pass = TextEditingController(),
      confirm = TextEditingController(),
      village = TextEditingController(),
      crop = TextEditingController(),
      farmSize = TextEditingController();
  final states = const {
    'Maharashtra': {
      'Pune': ['Haveli', 'Mulshi', 'Baramati'],
      'Nashik': ['Niphad', 'Sinnar', 'Dindori'],
    },
    'Gujarat': {
      'Ahmedabad': ['Daskroi', 'Dholka'],
      'Surat': ['Olpad', 'Bardoli'],
    },
    'Karnataka': {
      'Bengaluru Rural': ['Devanahalli', 'Hoskote'],
      'Mysuru': ['Mysuru', 'Nanjangud'],
    },
    'Tamil Nadu': {
      'Coimbatore': ['Pollachi', 'Sulur'],
      'Madurai': ['Melur', 'Usilampatti'],
    },
    'Telangana': {
      'Hyderabad': ['Charminar', 'Secunderabad'],
      'Warangal': ['Warangal', 'Hanamkonda'],
    },
    'Punjab': {
      'Ludhiana': ['Ludhiana East', 'Khanna'],
      'Amritsar': ['Ajnala', 'Baba Bakala'],
    },
    'West Bengal': {
      'Nadia': ['Krishnanagar', 'Ranaghat'],
      'Hooghly': ['Chinsurah', 'Arambagh'],
    },
    'Kerala': {
      'Palakkad': ['Palakkad', 'Alathur'],
      'Thrissur': ['Thrissur', 'Chalakudy'],
    },
    'Uttar Pradesh': {
      'Lucknow': ['Malihabad', 'Mohanlalganj'],
      'Varanasi': ['Pindra', 'Rajatalab'],
    },
    'Madhya Pradesh': {
      'Indore': ['Depalpur', 'Mhow'],
      'Bhopal': ['Huzur', 'Berasia'],
    },
  };
  final languages = const [
    'Marathi',
    'Hindi',
    'English',
    'Gujarati',
    'Kannada',
    'Tamil',
    'Telugu',
    'Punjabi',
    'Bengali',
    'Malayalam',
  ];
  List<String> get districts => states[state]!.keys.toList();
  List<String> get talukas => states[state]![district]!;
  void submit() {
    if (formKey.currentState!.validate())
      showOtp(context, () {
        AuthSession.signIn(UserRole.farmer);
        replace(context, const MainShell(role: UserRole.farmer));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const PageTop(
                title: 'Farmer Account',
                subtitle: 'Login or create your farmer profile',
                icon: Icons.agriculture_rounded,
              ),
              const SizedBox(height: 18),
              GlassCard(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: modeButton(
                        'Login',
                        !signup,
                        () => setState(() => signup = false),
                      ),
                    ),
                    Expanded(
                      child: modeButton(
                        'Signup',
                        signup,
                        () => setState(() => signup = true),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              GlassCard(
                child: signup
                    ? Column(
                        children: [
                          PremiumField(
                            controller: name,
                            label: 'Name *',
                            icon: Icons.person,
                            validator: requiredValidator,
                          ),
                          gap,
                          PremiumField(
                            controller: email,
                            label: 'Email *',
                            icon: Icons.email,
                            validator: emailValidator,
                          ),
                          gap,
                          PremiumField(
                            controller: mobile,
                            label: 'Mobile Number *',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: mobileValidator,
                          ),
                          gap,
                          PremiumField(
                            controller: pass,
                            label: 'Password *',
                            icon: Icons.lock,
                            obscureText: obscure,
                            validator: passwordValidator,
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => obscure = !obscure),
                              icon: const Icon(Icons.visibility),
                            ),
                          ),
                          gap,
                          PremiumField(
                            controller: confirm,
                            label: 'Confirm Password *',
                            icon: Icons.lock_reset,
                            obscureText: obscure,
                            validator: (v) => v == pass.text
                                ? null
                                : 'Passwords do not match',
                          ),
                          gap,
                          PremiumDropdown(
                            value: state,
                            items: states.keys.toList(),
                            label: 'State *',
                            icon: Icons.public,
                            onChanged: (v) => setState(() {
                              state = v!;
                              district = districts.first;
                              taluka = talukas.first;
                            }),
                          ),
                          gap,
                          PremiumDropdown(
                            value: district,
                            items: districts,
                            label: 'District *',
                            icon: Icons.location_city,
                            onChanged: (v) => setState(() {
                              district = v!;
                              taluka = talukas.first;
                            }),
                          ),
                          gap,
                          PremiumDropdown(
                            value: taluka,
                            items: talukas,
                            label: 'Taluka *',
                            icon: Icons.map,
                            onChanged: (v) => setState(() => taluka = v!),
                          ),
                          gap,
                          PremiumField(
                            controller: village,
                            label: 'Village *',
                            icon: Icons.home_work,
                            validator: requiredValidator,
                          ),
                          gap,
                          PremiumDropdown(
                            value: lang,
                            items: languages,
                            label: 'Preferred Language *',
                            icon: Icons.translate,
                            onChanged: (v) => setState(() => lang = v!),
                          ),
                          gap,
                          PremiumField(
                            controller: crop,
                            label: 'Main Crop *',
                            icon: Icons.grass,
                            validator: requiredValidator,
                          ),
                          gap,
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: PremiumField(
                                  controller: farmSize,
                                  label: 'Farm Size *',
                                  icon: Icons.square_foot,
                                  keyboardType: TextInputType.number,
                                  validator: numberValidator,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: PremiumDropdown(
                                  value: unit,
                                  items: const [
                                    'Acre',
                                    'Hectare',
                                    'Bigha',
                                    'Guntha',
                                  ],
                                  label: 'Unit',
                                  icon: Icons.straighten,
                                  onChanged: (v) => setState(() => unit = v!),
                                ),
                              ),
                            ],
                          ),
                          gap,
                          switchTile(
                            'Allow GPS Location *',
                            'Required for geo-tag verification and nearby buyers.',
                            Icons.gps_fixed,
                            gps,
                            (v) => setState(() => gps = v),
                          ),
                          gap,
                          switchTile(
                            'Allow Notifications *',
                            'Required for AI alerts and order updates.',
                            Icons.notifications_active,
                            notifications,
                            (v) => setState(() => notifications = v),
                          ),
                          gap,
                          FilledButton.icon(
                            onPressed: submit,
                            icon: const Icon(Icons.verified_user),
                            label: const Text('Signup & Verify OTP'),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          PremiumField(
                            controller: mobile,
                            label: 'Mobile Number *',
                            icon: Icons.phone,
                            validator: mobileValidator,
                          ),
                          gap,
                          PremiumField(
                            controller: pass,
                            label: 'Password *',
                            icon: Icons.lock,
                            obscureText: obscure,
                            validator: passwordValidator,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => showInfo(
                                context,
                                'Forgot Password',
                                'Password reset OTP sent.',
                              ),
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: submit,
                            icon: const Icon(Icons.login),
                            label: const Text('Login with OTP'),
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

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});
  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  String selectedCrop = 'Tomato';
  @override
  Widget build(BuildContext context) {
    final crop = DummyApi.prices.firstWhere((e) => e.crop == selectedCrop);
    return AppPage(
      title: 'AgriChain AI',
      subtitle: 'Farmer Dashboard',
      icon: Icons.agriculture_rounded,
      children: [
        PremiumGradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Good Morning, Ramesh',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your AI farm manager found weather, disease, market and buyer actions today.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: HeroMetric(
                      label: 'Trust Score',
                      value: '96%',
                      icon: Icons.verified,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: HeroMetric(
                      label: 'Active Crops',
                      value: '7',
                      icon: Icons.grass,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CardHeader(
                icon: Icons.thunderstorm,
                title: 'Weather',
                action: 'Live',
              ),
              SizedBox(height: 12),
              Text(
                '28 C - Rain chance 82%. Harvest mature crops before tomorrow morning.',
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(value: .82),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CardHeader(
                icon: Icons.task_alt,
                title: 'Today Priority',
                action: 'AI',
              ),
              SizedBox(height: 12),
              Text(
                '1. Upload tomato leaf photo if spots are visible.\n2. List 1.2 tons before 4 PM for verified traders.\n3. Keep 40% stock for tomorrow if rainfall reduces supply.',
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.price_change,
                title: 'Food Market Prices',
                action: 'Mandi',
              ),
              const SizedBox(height: 12),
              PremiumDropdown(
                value: selectedCrop,
                items: DummyApi.prices.map((e) => e.crop).toList(),
                label: 'Crop',
                icon: Icons.grass,
                onChanged: (v) => setState(() => selectedCrop = v!),
              ),
              const SizedBox(height: 14),
              Text(
                crop.price,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.deepGreen,
                ),
              ),
              Chip(label: Text(crop.change)),
              LineChart(values: crop.values),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.grid_view,
                title: 'Quick Actions',
                action: 'Active',
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: .92,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  quick(
                    context,
                    Icons.mic,
                    'Voice AI',
                    const AiVoiceChatbotScreen(),
                  ),
                  quick(
                    context,
                    Icons.chat,
                    'Text AI',
                    const AiVoiceChatbotScreen(),
                  ),
                  quick(
                    context,
                    Icons.camera_alt,
                    'Disease',
                    const DiseaseDetectionScreen(),
                  ),
                  quick(
                    context,
                    Icons.sell,
                    'Sell Crop',
                    const SellCropScreen(),
                  ),
                  quick(
                    context,
                    Icons.storefront,
                    'Market',
                    const MarketplaceScreen(),
                  ),
                  quick(
                    context,
                    Icons.store,
                    'Shopkeepers',
                    const MarketplaceScreen(filter: 'Shopkeepers'),
                  ),
                  quick(
                    context,
                    Icons.local_shipping,
                    'Traders',
                    const MarketplaceScreen(filter: 'Traders'),
                  ),
                  quick(
                    context,
                    Icons.map,
                    'Google Maps',
                    const MapOnlyScreen(),
                  ),
                  quick(
                    context,
                    Icons.account_balance,
                    'Schemes',
                    const FeatureScreen(
                      title: 'Government Schemes',
                      icon: Icons.account_balance,
                    ),
                  ),
                  quick(
                    context,
                    Icons.trending_up,
                    'Prediction',
                    const FeatureScreen(
                      title: 'Price Prediction',
                      icon: Icons.trending_up,
                    ),
                  ),
                  quick(
                    context,
                    Icons.wallet,
                    'Wallet',
                    const FeatureScreen(title: 'Wallet', icon: Icons.wallet),
                  ),
                  quick(
                    context,
                    Icons.receipt_long,
                    'Orders',
                    const FeatureScreen(
                      title: 'Orders',
                      icon: Icons.receipt_long,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const AiRecommendationPreview(),
        const DummyMapCard(),
      ],
    );
  }
}

class AiVoiceChatbotScreen extends StatefulWidget {
  const AiVoiceChatbotScreen({super.key});
  @override
  State<AiVoiceChatbotScreen> createState() => _AiVoiceChatbotScreenState();
}

class _AiVoiceChatbotScreenState extends State<AiVoiceChatbotScreen>
    with TickerProviderStateMixin {
  late final AnimationController orb;
  final input = TextEditingController();
  final scroll = ScrollController();
  String language = 'Marathi';
  String status = 'Ready to help';
  bool listening = false, speaking = false, typing = false, voice = true;
  final messages = <(bool, String)>[
    (
      false,
      'Namaste! Ask about crops, disease, price, weather, schemes, irrigation or selling.',
    ),
  ];
  final languages = const [
    'Marathi',
    'Hindi',
    'English',
    'Gujarati',
    'Kannada',
    'Tamil',
    'Telugu',
    'Punjabi',
    'Bengali',
    'Malayalam',
  ];
  @override
  void initState() {
    super.initState();
    orb = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    orb.dispose();
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  void send([String? text]) {
    final t = (text ?? input.text).trim();
    if (t.isEmpty) return;
    setState(() {
      messages.add((true, t));
      input.clear();
      typing = true;
      listening = false;
      speaking = false;
      status = 'Analyzing crop data...';
    });
    _scrollToBottom();
    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        typing = false;
        speaking = voice;
        status = voice ? 'Speaking answer' : 'Answer ready';
        messages.add((false, _answerFor(t)));
      });
      _scrollToBottom();
      if (voice)
        Timer(const Duration(milliseconds: 1400), () {
          if (mounted)
            setState(() {
              speaking = false;
              status = 'Ready to help';
            });
        });
    });
  }

  void _startVoiceDemo() {
    if (!voice) {
      setState(() => voice = true);
    }
    setState(() {
      listening = true;
      speaking = false;
      status = 'Listening to farmer query...';
    });
    Timer(const Duration(milliseconds: 800), () {
      if (mounted && listening)
        send('Check disease risk, weather and market price for tomato');
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      scroll.animateTo(
        scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  String _answerFor(String text) {
    final q = text.toLowerCase();
    final cropName = _detectCrop(q);
    final place = q.contains('nashik')
        ? 'Nashik'
        : q.contains('pune')
        ? 'Pune'
        : 'your nearby mandi';
    if (q.contains('disease') || q.contains('leaf') || q.contains('blight')) {
      return 'AI in $language\n'
          'Crop health scan: $cropName\n'
          'Likely issue: fungal leaf spot / early blight risk\n'
          'Confidence: 87%\n'
          'Why: yellowing edges, dark spots and recent humidity are common signals.\n'
          'Do now: upload 1 close leaf photo and 1 full plant photo in Disease Detection.\n'
          'Until confirmed: remove badly infected leaves, avoid overhead irrigation, keep spacing open and ask the shopkeeper for a fungicide label check.';
    }
    if (q.contains('sell') || q.contains('price') || q.contains('market')) {
      return 'AI in $language\n'
          'Market prediction for $cropName at $place\n'
          'Today range: Rs 28-31/kg\n'
          'Demand signal: strong buyer activity, 98% trader match nearby.\n'
          'Risk: rain can reduce quality after 24 hours.\n'
          'Recommendation: sell 60% today, keep 40% for 1-2 days only if crop quality is firm.\n'
          'Expected extra profit: Rs 5,400 to Rs 7,200 on 1.8 tons.';
    }
    if (q.contains('fertilizer') || q.contains('nutrition')) {
      return 'AI in $language\n'
          'Nutrition plan for $cropName\n'
          'Priority: soil-test based dosing.\n'
          'Current stage advice: split nitrogen, maintain potassium during fruiting and watch calcium deficiency if fruit bottom turns black.\n'
          'Avoid: heavy nitrogen before rain because it can increase soft growth and disease risk.\n'
          'Next step: upload soil report or ask shopkeeper for a crop-stage dose card.';
    }
    if (q.contains('weather') || q.contains('rain')) {
      return 'AI in $language\n'
          'Weather risk for $cropName\n'
          'Rain probability: 82%\n'
          'Disease pressure: medium-high because humidity is rising.\n'
          'Action today: finish spray before evening, pause irrigation and harvest mature produce before tomorrow morning.\n'
          'Safety: do not spray during wind or rain; follow pesticide label waiting period.';
    }
    if (q.contains('scheme') ||
        q.contains('insurance') ||
        q.contains('pmfby')) {
      return 'AI in $language\n'
          'Scheme match found\n'
          'Possible fit: PMFBY crop insurance and local horticulture subsidy.\n'
          'Documents needed: Aadhaar, 7/12 land record, bank passbook, crop photo and mobile number.\n'
          'Priority: apply before the rainfall damage window closes.\n'
          'I can help prepare an application checklist from your profile.';
    }
    if (q.contains('buyer') || q.contains('trader') || q.contains('nearby')) {
      return 'AI in $language\n'
          'Buyer matching for $cropName\n'
          'Best match: Nashik Fresh Traders, 98% match, pickup available today.\n'
          'Backup: Maharashtra Agro Mart, 89% match, bulk order preferred.\n'
          'Negotiation tip: ask for Rs 2/kg above mandi if quality grade is A.\n'
          'Next step: create a listing with photos and estimated quantity.';
    }
    return 'AI in $language\n'
        'Farm summary for $cropName\n'
        'I checked crop health, weather, mandi price and nearby buyers.\n'
        'Top priority: inspect leaves, protect against rain and shortlist verified buyers before listing.\n'
        'Confidence: 84%\n'
        'Ask me about disease, price, fertilizer, rain, schemes or buyers for a deeper answer.';
  }

  String _detectCrop(String q) {
    for (final crop in DummyApi.prices.map((e) => e.crop)) {
      if (q.contains(crop.toLowerCase())) return crop;
    }
    return 'Tomato';
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'AI Voice Chatbot',
      subtitle: 'Voice and text generative assistant',
      icon: Icons.mic_rounded,
      children: [
        GlassCard(
          child: Row(
            children: [
              Expanded(
                child: PremiumDropdown(
                  value: language,
                  items: languages,
                  label: 'Language Selection',
                  icon: Icons.translate,
                  onChanged: (v) => setState(() => language = v!),
                ),
              ),
              const SizedBox(width: 10),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    icon: Icon(Icons.mic),
                    label: Text('Voice'),
                  ),
                  ButtonSegment(
                    value: false,
                    icon: Icon(Icons.chat),
                    label: Text('Text'),
                  ),
                ],
                selected: {voice},
                onSelectionChanged: (v) => setState(() => voice = v.first),
              ),
            ],
          ),
        ),
        PremiumGradientCard(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: orb,
                builder: (_, __) => CustomPaint(
                  painter: AiOrbPainter(orb.value),
                  child: const SizedBox(width: 170, height: 170),
                ),
              ),
              Text(
                listening
                    ? 'Listening...'
                    : speaking
                    ? 'Speaking...'
                    : 'Ready in $language',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(status),
                backgroundColor: Colors.white.withOpacity(.18),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                side: BorderSide.none,
              ),
              const SizedBox(height: 8),
              Text(
                voice
                    ? 'Tap mic and the assistant will capture a sample farmer question, analyze it, and answer.'
                    : 'Type any crop, market, weather, scheme or disease question and press send.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(.8)),
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.tips_and_updates,
                title: 'Tap a quick question',
                action: 'Ready',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                          'When should I sell?',
                          'Fertilizer guidance',
                          'Weather risk',
                          'Government schemes',
                          'Disease prevention',
                          'Nearby buyers',
                        ]
                        .map(
                          (q) => ActionChip(
                            label: Text(q),
                            avatar: const Icon(Icons.auto_awesome, size: 18),
                            onPressed: () => send(q),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            children: [
              SizedBox(
                height: 360,
                child: ListView(
                  controller: scroll,
                  children: [
                    for (final m in messages)
                      Align(
                        alignment: m.$1
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          constraints: const BoxConstraints(maxWidth: 320),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: m.$1
                                ? AppTheme.green
                                : const Color(0xFFEFFFF7),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: m.$1
                                  ? AppTheme.green
                                  : AppTheme.green.withOpacity(.18),
                            ),
                          ),
                          child: Text(
                            m.$2,
                            style: TextStyle(
                              color: m.$1 ? Colors.white : AppTheme.deepGreen,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    if (typing)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'AI is typing...',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.deepGreen,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                children: [
                  IconButton.filled(
                    onPressed: () {
                      if (voice && !listening) {
                        _startVoiceDemo();
                      } else {
                        setState(() {
                          listening = false;
                          status = 'Voice stopped';
                        });
                      }
                    },
                    icon: Icon(listening ? Icons.stop : Icons.mic),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => setState(() => speaking = !speaking),
                    icon: Icon(speaking ? Icons.volume_off : Icons.volume_up),
                  ),
                  Expanded(
                    child: TextField(
                      controller: input,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => send(),
                      decoration: const InputDecoration(
                        hintText: 'Ask AI in simple words...',
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () => send(),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});
  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  bool image = false, processing = false, result = false;
  String source = '', crop = 'Tomato';
  final crops = const [
    'Tomato',
    'Onion',
    'Potato',
    'Wheat',
    'Rice',
    'Cotton',
    'Sugarcane',
  ];
  ({
    String disease,
    String confidence,
    String medicine,
    String prevention,
    String shop,
  })
  get diagnosis => switch (crop) {
    'Onion' => (
      disease: 'Purple Blotch',
      confidence: '91%',
      medicine: 'Mancozeb + sticker spray',
      prevention:
          'Improve air circulation, avoid excess nitrogen and remove infected leaves.',
      shop: 'Krushi Seva Kendra, 2.1 km',
    ),
    'Potato' => (
      disease: 'Late Blight Risk',
      confidence: '88%',
      medicine: 'Metalaxyl-M + Mancozeb',
      prevention:
          'Destroy infected foliage, keep field drainage open and avoid evening irrigation.',
      shop: 'Maharashtra Agro Mart, 5.8 km',
    ),
    'Wheat' => (
      disease: 'Leaf Rust',
      confidence: '86%',
      medicine: 'Propiconazole advisory dose',
      prevention:
          'Scout lower leaves, use resistant varieties next season and rotate crops.',
      shop: 'AgroCare Inputs, 3.4 km',
    ),
    _ => (
      disease: 'Early Blight',
      confidence: '94%',
      medicine: 'Mancozeb 75 WP',
      prevention:
          'Remove infected leaves, improve spacing and avoid overhead irrigation.',
      shop: 'Krushi Seva Kendra, 2.1 km',
    ),
  };

  void chooseImage(String nextSource) => setState(() {
    image = true;
    source = nextSource;
    result = false;
  });

  void process() {
    if (!image) return;
    setState(() {
      processing = true;
      result = false;
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted)
        setState(() {
          processing = false;
          result = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Crop Disease Detection',
      subtitle: 'AI-powered crop health analysis',
      icon: Icons.health_and_safety,
      children: [
        PremiumGradientCard(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.16),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(.24)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      image ? Icons.image_search : Icons.add_a_photo,
                      color: Colors.white,
                      size: 78,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      image
                          ? '$source selected for $crop'
                          : 'No crop image selected',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                processing
                    ? 'AI Processing...'
                    : image
                    ? 'Image ready for AI analysis'
                    : 'Take Photo or Upload Image',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (processing)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(color: Colors.white),
                ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            children: [
              PremiumDropdown(
                value: crop,
                items: crops,
                label: 'Crop Type',
                icon: Icons.grass,
                onChanged: (v) => setState(() {
                  crop = v!;
                  result = false;
                }),
              ),
              gap,
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => chooseImage('Camera photo'),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => chooseImage('Gallery image'),
                      icon: const Icon(Icons.image),
                      label: const Text('Upload Image'),
                    ),
                  ),
                ],
              ),
              gap,
              FilledButton.icon(
                onPressed: image && !processing ? process : null,
                icon: const Icon(Icons.psychology),
                label: const Text('Run AI Diagnosis'),
              ),
            ],
          ),
        ),
        if (result)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardHeader(
                  icon: Icons.warning,
                  title: 'Disease Result',
                  action: diagnosis.confidence,
                ),
                const SizedBox(height: 12),
                Text(
                  'Crop: $crop\nDisease: ${diagnosis.disease}\nConfidence Score: ${diagnosis.confidence}\nMedicine: ${diagnosis.medicine}\nPrevention: ${diagnosis.prevention}\nNearby Agriculture Shop: ${diagnosis.shop}',
                ),
                const SizedBox(height: 12),
                const LinearProgressIndicator(value: .94),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    Chip(label: Text('Save report')),
                    Chip(label: Text('Share with shop')),
                    Chip(label: Text('Book expert call')),
                  ],
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() {
                  image = false;
                  result = false;
                }),
                icon: const Icon(Icons.refresh),
                label: const Text('Retake'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => showInfo(
                  context,
                  'History',
                  'Tomato Early Blight diagnosed successfully. Verification logs saved.',
                ),
                icon: const Icon(Icons.history),
                label: const Text('History'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// ADDED & MODIFIED FEATURES (NEW CODE BELOW)
// ==========================================

const gap = SizedBox(height: 16);

String? requiredValidator(String? v) =>
    v == null || v.trim().isEmpty ? 'This field is required' : null;
String? emailValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim()))
    return 'Enter a valid email';
  return null;
}

String? mobileValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Mobile number is required';
  if (!RegExp(r'^\d{10}$').hasMatch(v.trim()))
    return 'Enter a valid 10-digit mobile number';
  return null;
}

String? passwordValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Password is required';
  if (v.length < 6) return 'Password must be at least 6 characters';
  return null;
}

String? numberValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Required';
  if (double.tryParse(v) == null) return 'Enter a valid number';
  return null;
}

class BackgroundPainter extends CustomPainter {
  final bool light;
  BackgroundPainter({required this.light});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = light
          ? Colors.white.withOpacity(0.25)
          : Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = light
          ? Colors.white.withOpacity(0.15)
          : Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.9,
      size.width * 0.6,
      size.height * 0.75,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.65,
      size.width,
      size.height * 0.72,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlassLogo extends StatelessWidget {
  final double size;
  const GlassLogo({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.green.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: Icon(
              Icons.eco_rounded,
              size: size * 0.55,
              color: AppTheme.deepGreen,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBg extends StatelessWidget {
  final Widget child;
  const GradientBg({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final isDark = AppScope.of(context).themeMode == ThemeMode.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF030D0A),
                  const Color(0xFF081C15),
                  const Color(0xFF0F3A2C),
                ]
              : [
                  const Color(0xFFEFFFF7),
                  const Color(0xFFBDF7D6),
                  const Color(0xFFE8FDF3),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: BackgroundPainter(light: !isDark)),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class FloatingIllustration extends StatefulWidget {
  final IconData icon;
  final Color color;
  const FloatingIllustration({
    super.key,
    required this.icon,
    required this.color,
  });
  @override
  State<FloatingIllustration> createState() => _FloatingIllustrationState();
}

class _FloatingIllustrationState extends State<FloatingIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, sin(_ac.value * pi * 2) * 12),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.08),
                  ),
                ),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.12),
                  ),
                ),
                Icon(widget.icon, size: 84, color: widget.color),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const GlassCard({super.key, required this.child, this.padding, this.margin});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
              : [Colors.white.withOpacity(0.7), Colors.white.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(18),
            child: child,
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final UserRole role;
  final String description;
  final List<Color> colors;
  final VoidCallback onTap;
  const RoleCard({
    super.key,
    required this.role,
    required this.description,
    required this.colors,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(role.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

void showInfo(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showOtp(BuildContext context, VoidCallback onVerified) {
  final code = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Column(
        children: [
          const Icon(Icons.security, size: 48, color: AppTheme.green),
          const SizedBox(height: 12),
          const Text(
            'Enter 4-Digit OTP',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'Sent to your registered mobile number',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: code,
            maxLength: 4,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              letterSpacing: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              counterText: '',
              hintText: '0000',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => showInfo(
              context,
              'Resend OTP',
              'Verification OTP resent to your phone.',
            ),
            child: const Text('Resend Code'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (code.text.length == 4) {
              Navigator.pop(ctx);
              onVerified();
            }
          },
          child: const Text('Verify'),
        ),
      ],
    ),
  );
}

class PremiumGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const PremiumGradientCard({super.key, required this.child, this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppTheme.heroGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepGreen.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(22),
        child: child,
      ),
    );
  }
}

class PremiumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;
  const PremiumField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffix,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
      ),
    );
  }
}

class UploadBox extends StatelessWidget {
  final String title;
  final bool active;
  final IconData icon;
  final VoidCallback onTap;
  const UploadBox({
    super.key,
    required this.title,
    required this.active,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: active ? AppTheme.green.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? AppTheme.green : Colors.grey.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              active ? Icons.check_circle : icon,
              color: active ? AppTheme.green : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? AppTheme.green : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget switchTile(
  String title,
  String subtitle,
  IconData icon,
  bool value,
  ValueChanged<bool> onChanged,
) {
  return SwitchListTile(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    secondary: Icon(icon),
    value: value,
    onChanged: onChanged,
  );
}

class PremiumDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final String label;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  const PremiumDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.icon,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
  }
}

class HeroMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const HeroMetric({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String action;
  const CardHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.action,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.deepGreen, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepGreen,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppTheme.green,
            ),
          ),
        ),
      ],
    );
  }
}

class LineChart extends StatelessWidget {
  final List<double> values;
  const LineChart({super.key, required this.values});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      child: CustomPaint(painter: _ChartPainter(values)),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> values;
  _ChartPainter(this.values);
  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final paint = Paint()
      ..color = AppTheme.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.green.withOpacity(0.35),
          AppTheme.green.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final maxVal = values.reduce(max);
    final minVal = values.reduce(min);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final widthStep = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = i * widthStep;
      final normalizedY = (values[i] - minVal) / range;
      final y = size.height - (normalizedY * (size.height - 20) + 10);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final pointPaint = Paint()
      ..color = AppTheme.deepGreen
      ..style = PaintingStyle.fill;
    for (int i = 0; i < values.length; i++) {
      final x = i * widthStep;
      final normalizedY = (values[i] - minVal) / range;
      final y = size.height - (normalizedY * (size.height - 20) + 10);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget quick(BuildContext context, IconData icon, String label, Widget page) {
  return GestureDetector(
    onTap: () => go(context, page),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.green.withOpacity(0.12),
            child: Icon(icon, size: 20, color: AppTheme.green),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

class AiRecommendationPreview extends StatelessWidget {
  const AiRecommendationPreview({super.key});
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.amber.withOpacity(0.15),
            child: const Icon(Icons.auto_awesome, color: AppTheme.amber),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Market Insight',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mandi price of tomato is forecasted to hit Rs 32/kg due to local supply gaps. Sell in 48 hours.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
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
}

class DummyMapCard extends StatelessWidget {
  const DummyMapCard({super.key});
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardHeader(
            icon: Icons.map,
            title: 'Stakeholder Map',
            action: 'GPS active',
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.blue.withOpacity(0.08),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  const Center(
                    child: Icon(Icons.my_location, color: Colors.red, size: 28),
                  ),
                  Positioned(
                    top: 25,
                    left: 45,
                    child: _mapPin(
                      Icons.agriculture_rounded,
                      AppTheme.green,
                      'Farmer Ramesh',
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 60,
                    child: _mapPin(
                      Icons.local_shipping_rounded,
                      AppTheme.amber,
                      'Nashik Traders',
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 80,
                    child: _mapPin(
                      Icons.storefront_rounded,
                      AppTheme.blue,
                      'Krushi Seva Shop',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPin(IconData icon, Color col, String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: col,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.12)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AiOrbPainter extends CustomPainter {
  final double progress;
  AiOrbPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    final glowPaint = Paint()
      ..color = AppTheme.green.withOpacity(0.2 + 0.1 * sin(progress * pi * 2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius + 10, glowPaint);

    final circlePaint = Paint()
      ..shader = RadialGradient(
        colors: [AppTheme.green.withOpacity(0.8), AppTheme.deepGreen],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 5; i++) {
      final waveHeight = 12 + 18 * sin((progress + i * 0.25) * pi * 2);
      final x = center.dx - 40 + i * 20;
      canvas.drawLine(
        Offset(x, center.dy - waveHeight / 2),
        Offset(x, center.dy + waveHeight / 2),
        wavePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AppPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;
  const AppPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(icon, color: AppTheme.deepGreen),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              AppScope.of(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => AppScope.of(context).toggleTheme(),
          ),
        ],
      ),
      body: GradientBg(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: children,
        ),
      ),
    );
  }
}

Widget modeButton(String text, bool active, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active ? AppTheme.green : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: active ? Colors.white : AppTheme.deepGreen,
        ),
      ),
    ),
  );
}

void showAiSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: Theme.of(ctx).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.5),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(ctx).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: AppTheme.green),
              SizedBox(width: 10),
              Text(
                'AgriChain Global AI Agent',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'I can automatically analyze supply rates, book trucks, and set field irrigation schedules from here.',
            style: TextStyle(color: Colors.grey, height: 1.3),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text('Optimize Tomato Selling'),
                onPressed: () => Navigator.pop(ctx),
              ),
              ActionChip(
                label: const Text('Schedule Soil Watering'),
                onPressed: () => Navigator.pop(ctx),
              ),
              ActionChip(
                label: const Text('Calculate Profit margins'),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Instruct global agent...',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                onPressed: () {
                  Navigator.pop(ctx);
                  showInfo(
                    context,
                    'Agent Request',
                    'Instruction sent to global coordinator.',
                  );
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class PageTop extends StatelessWidget {
  const PageTop({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title, subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.green.withOpacity(0.15),
              child: Icon(icon, color: AppTheme.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepGreen,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}

class ShopkeeperRegistrationScreen extends StatefulWidget {
  const ShopkeeperRegistrationScreen({super.key});
  @override
  State<ShopkeeperRegistrationScreen> createState() =>
      _ShopkeeperRegistrationScreenState();
}

class _ShopkeeperRegistrationScreenState
    extends State<ShopkeeperRegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final license = TextEditingController();
  final address = TextEditingController();
  final contact = TextEditingController();
  bool agreed = true;

  @override
  void dispose() {
    name.dispose();
    license.dispose();
    address.dispose();
    contact.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      showOtp(context, () {
        AuthSession.signIn(UserRole.shopkeeper);
        replace(context, const MainShell(role: UserRole.shopkeeper));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const PageTop(
                title: 'Shopkeeper Register',
                subtitle: 'List your agriculture inputs store',
                icon: Icons.storefront_rounded,
              ),
              gap,
              GlassCard(
                child: Column(
                  children: [
                    PremiumField(
                      controller: name,
                      label: 'Store Name *',
                      icon: Icons.store,
                      validator: requiredValidator,
                    ),
                    gap,
                    PremiumField(
                      controller: license,
                      label: 'Fertilizer License Number *',
                      icon: Icons.description,
                      validator: requiredValidator,
                    ),
                    gap,
                    PremiumField(
                      controller: address,
                      label: 'Business Address *',
                      icon: Icons.location_on,
                      validator: requiredValidator,
                    ),
                    gap,
                    PremiumField(
                      controller: contact,
                      label: 'Store Mobile *',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: mobileValidator,
                    ),
                    gap,
                    switchTile(
                      'Consent to location listing',
                      'Allow nearby farmers to see your inputs inventory.',
                      Icons.share_location,
                      agreed,
                      (v) => setState(() => agreed = v),
                    ),
                    gap,
                    FilledButton.icon(
                      onPressed: submit,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Register inputs Shop'),
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

class TraderRegistrationScreen extends StatefulWidget {
  const TraderRegistrationScreen({super.key});
  @override
  State<TraderRegistrationScreen> createState() =>
      _TraderRegistrationScreenState();
}

class _TraderRegistrationScreenState extends State<TraderRegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  final companyName = TextEditingController();
  final lincenseNo = TextEditingController();
  final transportCount = TextEditingController();
  final mobileNo = TextEditingController();
  bool gpsTracking = true;

  @override
  void dispose() {
    companyName.dispose();
    lincenseNo.dispose();
    transportCount.dispose();
    mobileNo.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      showOtp(context, () {
        AuthSession.signIn(UserRole.trader);
        replace(context, const MainShell(role: UserRole.trader));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBg(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const PageTop(
                title: 'Trader Registration',
                subtitle: 'Join direct bulk trading console',
                icon: Icons.local_shipping_rounded,
              ),
              gap,
              GlassCard(
                child: Column(
                  children: [
                    PremiumField(
                      controller: companyName,
                      label: 'Trading/Logistics Company Name *',
                      icon: Icons.business,
                      validator: requiredValidator,
                    ),
                    gap,
                    PremiumField(
                      controller: lincenseNo,
                      label: 'APMC License Number *',
                      icon: Icons.badge_rounded,
                      validator: requiredValidator,
                    ),
                    gap,
                    PremiumField(
                      controller: transportCount,
                      label: 'Available Transport Fleets (Trucks) *',
                      icon: Icons.airport_shuttle,
                      keyboardType: TextInputType.number,
                      validator: numberValidator,
                    ),
                    gap,
                    PremiumField(
                      controller: mobileNo,
                      label: 'Business Contact Number *',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: mobileValidator,
                    ),
                    gap,
                    switchTile(
                      'Share live GPS transport details',
                      'Helps farmers request pickups directly.',
                      Icons.gps_fixed,
                      gpsTracking,
                      (v) => setState(() => gpsTracking = v),
                    ),
                    gap,
                    FilledButton.icon(
                      onPressed: submit,
                      icon: const Icon(Icons.verified),
                      label: const Text('Verify Agency & Signup'),
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

class ShopkeeperDashboardScreen extends StatefulWidget {
  const ShopkeeperDashboardScreen({super.key});
  @override
  State<ShopkeeperDashboardScreen> createState() =>
      _ShopkeeperDashboardScreenState();
}

class _ShopkeeperDashboardScreenState extends State<ShopkeeperDashboardScreen> {
  final inventory = [
    ('Organic Urea', 0.28, 'Restock ASAP'),
    ('NPK Fertilizer', 0.72, 'Optimal'),
    ('Crop Boost Spray', 0.88, 'Optimal'),
    ('Hybrid Tomato Seeds', 0.15, 'Critical restock'),
  ];
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Krushi Inputs Hub',
      subtitle: 'Shopkeeper Dashboard',
      icon: Icons.storefront_rounded,
      children: [
        PremiumGradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Welcome back, Raju',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your stock level is healthy. 12 farmers nearby requested stock verification.',
                style: TextStyle(color: Colors.white70, height: 1.35),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: HeroMetric(
                      label: 'Pending orders',
                      value: '4 orders',
                      icon: Icons.receipt,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: HeroMetric(
                      label: 'Today Sale',
                      value: 'Rs 18,200',
                      icon: Icons.payments,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.inventory_2,
                title: 'Store Stock Levels',
                action: 'Live inventory',
              ),
              const SizedBox(height: 14),
              for (final item in inventory)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.$1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item.$3,
                            style: TextStyle(
                              fontSize: 11,
                              color: item.$2 < 0.3
                                  ? AppTheme.red
                                  : AppTheme.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: item.$2,
                        color: item.$2 < 0.3 ? AppTheme.red : AppTheme.green,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.people_outline,
                title: 'Farmer Demand Requests',
                action: 'Verification',
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.agriculture)),
                title: const Text('Ramesh Patil'),
                subtitle: const Text('Requested 2 bags Urea, 1 bag NPK'),
                trailing: FilledButton(
                  onPressed: () => showInfo(
                    context,
                    'Approved',
                    'Urea voucher approved for Ramesh Patil.',
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TraderDashboardScreen extends StatefulWidget {
  const TraderDashboardScreen({super.key});
  @override
  State<TraderDashboardScreen> createState() => _TraderDashboardScreenState();
}

class _TraderDashboardScreenState extends State<TraderDashboardScreen> {
  double bidPrice = 30.0;
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Logistics Control',
      subtitle: 'Trader Dashboard',
      icon: Icons.local_shipping_rounded,
      children: [
        PremiumGradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Nashik Fresh Traders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Active fleet routing: 3 trucks transit, 1 idle. Mandi tomato demands are peaking.',
                style: TextStyle(color: Colors.white70, height: 1.35),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: HeroMetric(
                      label: 'Total Purchased',
                      value: '4.8 Tons',
                      icon: Icons.scale,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: HeroMetric(
                      label: 'Active Fleets',
                      value: '3 Active',
                      icon: Icons.local_shipping,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.gavel,
                title: 'Bidding Center (Tomato)',
                action: 'Mandi Live',
              ),
              const SizedBox(height: 14),
              Text(
                'Current bid rate: Rs ${bidPrice.toStringAsFixed(1)}/kg',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: bidPrice,
                min: 25.0,
                max: 40.0,
                onChanged: (v) => setState(() => bidPrice = v),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Min: Rs 25'),
                  FilledButton(
                    onPressed: () => showInfo(
                      context,
                      'Bid Posted',
                      'Tomato buying bid posted at Rs ${bidPrice.toStringAsFixed(1)}/kg.',
                    ),
                    child: const Text('Update Live Bid'),
                  ),
                  const Text('Max: Rs 40'),
                ],
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CardHeader(
                icon: Icons.map,
                title: 'Transit Tracker',
                action: 'GPS map',
              ),
              SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.local_shipping)),
                title: Text('Truck #MH-15-EG-4932'),
                subtitle: Text('En route to Ramesh Patil (Tomato pickup)'),
                trailing: Chip(label: Text('4.2 km')),
              ),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.local_shipping)),
                title: Text('Truck #MH-15-DF-9104'),
                subtitle: Text('Delivered bulk Potato to Mandi'),
                trailing: Chip(label: Text('Completed')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final verifications = [
    ('Ramesh Patil', 'Farmer', 'Tomato profile & Aadhaar doc'),
    ('Krushi Seva Shop', 'Shopkeeper', 'Seed & fertilizer permit'),
    ('Nashik Fresh Traders', 'Trader', 'APMC registration doc'),
  ];
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Console Control',
      subtitle: 'Platform Administrator',
      icon: Icons.admin_panel_settings_rounded,
      children: [
        PremiumGradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Platform Operations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Review pending licenses, verify users and monitor direct crop trades on AgriChain network.',
                style: TextStyle(color: Colors.white70, height: 1.35),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: HeroMetric(
                      label: 'Total trades',
                      value: 'Rs 8.4 Lakh',
                      icon: Icons.show_chart,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: HeroMetric(
                      label: 'Verified Members',
                      value: '1,480 Active',
                      icon: Icons.people,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.verified_user_outlined,
                title: 'Identity Verification Queue',
                action: 'Pending',
              ),
              const SizedBox(height: 12),
              for (final v in verifications)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.person_search)),
                  title: Text(v.$1),
                  subtitle: Text('${v.$2} - ${v.$3}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: AppTheme.green),
                        onPressed: () => showInfo(
                          context,
                          'Approved',
                          '${v.$1} account has been successfully verified.',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppTheme.red),
                        onPressed: () => showInfo(
                          context,
                          'Rejected',
                          'Rejected documents of ${v.$1}.',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class MarketplaceScreen extends StatefulWidget {
  final String? filter;
  const MarketplaceScreen({super.key, this.filter});
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  late String currentFilter;
  final search = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentFilter = widget.filter ?? 'All';
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = DummyApi.members.where((e) {
      if (currentFilter != 'All' && e.type != currentFilter) return false;
      if (search.text.isNotEmpty &&
          !e.name.toLowerCase().contains(search.text.toLowerCase()))
        return false;
      return true;
    }).toList();

    return AppPage(
      title: 'Smart Marketplace',
      subtitle: 'Direct peer trading network',
      icon: Icons.storefront_rounded,
      children: [
        GlassCard(
          child: Column(
            children: [
              TextField(
                controller: search,
                onChanged: (v) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search members, crops, inputs...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Farmers', 'Shopkeepers', 'Traders'].map((
                    f,
                  ) {
                    final active = currentFilter == f;
                    return GestureDetector(
                      onTap: () => setState(() => currentFilter = f),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppTheme.green
                              : AppTheme.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: active ? Colors.white : AppTheme.deepGreen,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        for (final m in filteredMembers)
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (ctx) => Container(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: m.color.withOpacity(0.15),
                            child: Icon(m.icon, color: m.color),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(m.type),
                            ],
                          ),
                          const Spacer(),
                          if (m.verified)
                            const Icon(Icons.verified, color: AppTheme.green),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text('Listing Detail: ${m.subtitle}'),
                      Text('Estimated price: ${m.price}'),
                      Text('Rating: ${m.rating} ★'),
                      Text('AI trust score match: ${m.aiScore}%'),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.phone),
                              label: const Text('Call'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                showInfo(
                                  context,
                                  'Deal Initiated',
                                  'Direct deal request sent to ${m.name}. AI escrow started.',
                                );
                              },
                              icon: const Icon(Icons.handshake),
                              label: const Text('Initiate Deal'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            child: GlassCard(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: m.color.withOpacity(0.15),
                    child: Icon(m.icon, color: m.color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              m.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (m.verified)
                              const Icon(
                                Icons.verified,
                                color: AppTheme.green,
                                size: 16,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${m.distance} km away',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.auto_awesome,
                              size: 12,
                              color: AppTheme.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'AI Match: ${m.aiScore}%',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        m.price,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.deepGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${m.rating} ★',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class AiFarmManagerScreen extends StatefulWidget {
  const AiFarmManagerScreen({super.key});
  @override
  State<AiFarmManagerScreen> createState() => _AiFarmManagerScreenState();
}

class _AiFarmManagerScreenState extends State<AiFarmManagerScreen> {
  bool irrigationValve = false;
  double soilMoisture = 0.42;
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'AI Farm Manager',
      subtitle: 'Agentic field IoT operations',
      icon: Icons.sensors_rounded,
      children: [
        PremiumGradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Smart Telemetry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'AI sensor agents verified field moisture is low. Recommended irrigation valve trigger.',
                style: TextStyle(color: Colors.white70, height: 1.35),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: HeroMetric(
                      label: 'NPK level',
                      value: 'Optimal',
                      icon: Icons.grass,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: HeroMetric(
                      label: 'Soil pH',
                      value: '6.8 pH',
                      icon: Icons.science,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                icon: Icons.water_drop,
                title: 'Moisture telemetry',
                action: 'IoT active',
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Field Soil Moisture',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${(soilMoisture * 100).toStringAsFixed(0)}%'),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: soilMoisture,
                color: soilMoisture < 0.5 ? Colors.orange : AppTheme.green,
              ),
              const SizedBox(height: 14),
              switchTile(
                'Water Drip Valve',
                'Activate IoT water pumps directly from dashboard.',
                Icons.power_settings_new,
                irrigationValve,
                (v) => setState(() {
                  irrigationValve = v;
                  soilMoisture = v ? 0.76 : 0.42;
                }),
              ),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CardHeader(
                icon: Icons.calendar_today,
                title: 'Field Crop Calendar',
                action: 'Rotation',
              ),
              SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Icon(Icons.grass)),
                title: Text('Sowing Stage - Tomato'),
                subtitle: Text(
                  'Days remaining for split fertilizer dose: 4 days',
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Icon(Icons.rotate_right)),
                title: Text('Next Rotation - Chickpea'),
                subtitle: Text(
                  'Leguminous crop suggested by AI to restore nitrogen.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SellCropScreen extends StatefulWidget {
  const SellCropScreen({super.key});
  @override
  State<SellCropScreen> createState() => _SellCropScreenState();
}

class _SellCropScreenState extends State<SellCropScreen> {
  final cropName = TextEditingController();
  final quantity = TextEditingController();
  final targetPrice = TextEditingController();
  bool gradingDone = false;
  String cropGrade = 'Undetected';

  @override
  void dispose() {
    cropName.dispose();
    quantity.dispose();
    targetPrice.dispose();
    super.dispose();
  }

  void analyzeGrade() {
    setState(() {
      gradingDone = true;
      cropGrade = 'Grade A (Premium quality)';
      targetPrice.text = '32.0';
    });
    showInfo(
      context,
      'AI analysis complete',
      'Crop grade estimated: Grade A. Suggested price updated.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'List Crop for Sale',
      subtitle: 'Post direct deal on market console',
      icon: Icons.sell_rounded,
      children: [
        GlassCard(
          child: Column(
            children: [
              PremiumField(
                controller: cropName,
                label: 'Crop name *',
                icon: Icons.grass,
                validator: requiredValidator,
              ),
              gap,
              PremiumField(
                controller: quantity,
                label: 'Estimated Quantity (Tons) *',
                icon: Icons.scale,
                keyboardType: TextInputType.number,
                validator: numberValidator,
              ),
              gap,
              PremiumField(
                controller: targetPrice,
                label: 'Target Price (per kg) *',
                icon: Icons.payments,
                keyboardType: TextInputType.number,
                validator: numberValidator,
              ),
              gap,
              UploadBox(
                title: gradingDone
                    ? 'AI Grade: $cropGrade'
                    : 'Upload Crop photo for AI Grading',
                active: gradingDone,
                icon: Icons.camera_alt,
                onTap: analyzeGrade,
              ),
              gap,
              FilledButton.icon(
                onPressed: () {
                  if (cropName.text.isNotEmpty && quantity.text.isNotEmpty) {
                    showInfo(
                      context,
                      'Success',
                      'Crop listed in marketplace. Nearby traders notified.',
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.publish),
                label: const Text('Post Crop Listing'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MapOnlyScreen extends StatelessWidget {
  const MapOnlyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Mandi Rates & Fleets',
      subtitle: 'Real-time GPS mapping',
      icon: Icons.map,
      children: const [
        DummyMapCard(),
        GlassCard(
          child: ListTile(
            leading: Icon(Icons.storefront, color: AppTheme.green),
            title: Text('Pune Mandi Price'),
            subtitle: Text('Tomato: Rs 29/kg | Onion: Rs 22/kg'),
          ),
        ),
        GlassCard(
          child: ListTile(
            leading: Icon(Icons.storefront, color: AppTheme.blue),
            title: Text('Nashik Mandi Price'),
            subtitle: Text('Tomato: Rs 31/kg | Onion: Rs 21/kg'),
          ),
        ),
      ],
    );
  }
}

class FeatureScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const FeatureScreen({super.key, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: title,
      subtitle: 'Dashboard feature Console',
      icon: icon,
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: AppTheme.green),
              const SizedBox(height: 14),
              Text(
                '$title system is active.',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI and payment smart-contracts details are fully secured. Logs are synced with the dashboard console.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileSettingsScreen extends StatefulWidget {
  final UserRole role;
  const ProfileSettingsScreen({super.key, required this.role});
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool pushNotify = true;
  String currentLang = 'Marathi';
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Settings',
      subtitle: 'Account operations',
      icon: Icons.person_rounded,
      children: [
        GlassCard(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.green.withOpacity(0.15),
                child: Icon(
                  widget.role.icon,
                  size: 40,
                  color: AppTheme.deepGreen,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ramesh Patil',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Account Role: ${widget.role.label}'),
            ],
          ),
        ),
        GlassCard(
          child: Column(
            children: [
              PremiumDropdown(
                value: currentLang,
                items: const [
                  'Marathi',
                  'Hindi',
                  'English',
                  'Gujarati',
                  'Kannada',
                ],
                label: 'System Language',
                icon: Icons.translate,
                onChanged: (v) => setState(() => currentLang = v!),
              ),
              gap,
              switchTile(
                'Push notifications alerts',
                'Receive live mandi rate change SMS & app notifications.',
                Icons.notifications,
                pushNotify,
                (v) => setState(() => pushNotify = v),
              ),
              gap,
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Export Transaction statement'),
                onTap: () => showInfo(
                  context,
                  'Downloaded',
                  'Statements exported successfully.',
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.red),
                title: const Text(
                  'Sign out',
                  style: TextStyle(
                    color: AppTheme.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  AuthSession.signOut(widget.role);
                  replace(context, const RoleSelectionScreen());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
