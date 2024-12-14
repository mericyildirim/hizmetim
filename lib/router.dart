import 'package:flutter/material.dart';
import 'package:hizmetim/features/home/screens/home_screen.dart';
import 'package:hizmetim/features/auth/screens/login_screen.dart';
import 'package:hizmetim/features/auth/screens/signup_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SignupScreen()),
  '/login': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});
