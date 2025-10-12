import 'package:e_commerce/core/providers/auth_provider.dart';
import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/core/services/dummy_json_api_service.dart';
import 'package:e_commerce/core/services/firebase_auth_service.dart';
import 'package:e_commerce/core/services/firebase_auth_service_impl.dart';
import 'package:e_commerce/features/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/product_provider.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/favorites_provider.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ToastificationWrapper(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => DummyJsonApiService(client: http.Client()),
        ),
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthServiceImpl(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) =>
              AuthenticationProvider(context.read<FirebaseAuthService>()),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'E-Commerce App',
            theme: themeProvider.currentThemeData,
            darkTheme: themeProvider.currentTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: SplashScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/signup': (context) => SignUpScreen(),
              '/home': (context) => HomeScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
