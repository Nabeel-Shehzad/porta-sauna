// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:portasauna/core/routes/route_names.dart';
// import 'package:portasauna/features/auth/presentation/forgot_pass_page.dart';
// import 'package:portasauna/features/auth/presentation/login_page.dart';
// import 'package:portasauna/features/auth/presentation/signup_page.dart';
// import 'package:portasauna/features/home/presentation/landing_page.dart';
// import 'package:portasauna/features/intro/presentation/splash_page.dart';

// class AppRouter {
//   static final GoRouter goRouter = GoRouter(
//       errorPageBuilder: (context, state) => _errorPage(state),
//       routes: [
//         GoRoute(
//           path: RouteNames.splashPage,
//           name: RouteNames.splashPage,
//           builder: (context, state) => const SplashPage(),
//         ),
//         GoRoute(
//           path: RouteNames.login,
//           name: RouteNames.login,
//           builder: (context, state) => const LoginPage(),
//         ),
//         GoRoute(
//           path: RouteNames.signUp,
//           name: RouteNames.signUp,
//           builder: (context, state) => const SignupPage(),
//         ),
//         GoRoute(
//           path: RouteNames.forgotPassPage,
//           name: RouteNames.forgotPassPage,
//           builder: (context, state) => const ForgotPassPage(),
//         ),
//         GoRoute(
//           path: RouteNames.landingPage,
//           name: RouteNames.landingPage,
//           builder: (context, state) => const LandingPage(),
//         ),
//       ]);
// }

// MaterialPage<dynamic> _errorPage(GoRouterState state) {
//   return MaterialPage(
//     key: state.pageKey,
//     child: _errorPageContent(state),
//   );
// }

// Scaffold _errorPageContent(GoRouterState state) {
//   return Scaffold(
//     appBar: AppBar(title: const Text('Error')),
//     body: Center(child: Text(state.error.toString())),
//   );
// }
