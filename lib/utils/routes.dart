import 'package:flutter/material.dart';
import '../screens/draft_issuances.dart';
import '../screens/joint_circulars.dart';
import '../screens/latest_issuances.dart';
import '../screens/legal_opinions.dart';
import '../screens/memo_circulars.dart';
import '../screens/presidential_directives.dart';
import '../screens/republic_acts.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/library_screen.dart';
import '../screens/login_screen.dart';
import '../screens/edit_user.dart';
import '../screens/change_password_screen.dart';
import '../screens/settings_screen.dart';

class Routes {
  static const String home = '/';
  static const String search = '/search';
  static const String library = '/library';
  static const String introsection = '/introsection';
  static const String latestIssuances = '/latest-issuances';
  static const String jointCirculars = '/joint-circulars';
  static const String memoCirculars = '/memo-circulars';
  static const String presidentialDirectives = '/presidential-directives';
  static const String draftIssuances = '/draft-issuances';
  static const String republicActs = '/republic-acts';
  static const String legalOpinions = '/legal-opinions';
  static const String login = '/login';
  static const String editUser = '/edit_user';
  static const String changePassword = '/change-password';
  static const String setting = '/settings';

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      home: (context) => const HomeScreen(),
      search: (context) => SearchScreen(),
      'library': (context) => LibraryScreen(
            onFileOpened: (fileName, filePath) {
              // Implement your logic when file is opened
              print('File opened: $fileName');
            },
            onFileDeleted: (filePath) {
              // Implement your logic when file is deleted
              print('File deleted: $filePath');
            },
          ),
      // introsection: (context) => IntroSection(),
      latestIssuances: (context) => LatestIssuances(),
      jointCirculars: (context) => JointCirculars(),
      memoCirculars: (context) => MemoCirculars(),
      presidentialDirectives: (context) => PresidentialDirectives(),
      draftIssuances: (context) => DraftIssuances(),
      republicActs: (context) => RepublicActs(),
      legalOpinions: (context) => LegalOpinions(),
      login: (context) => LoginScreen(
            title: 'login',
          ),
      editUser: (context) => EditUser(),
      changePassword: (context) => ChangePasswordScreen(),
      setting: (context)  => SettingsScreen(),   
    };
  }
}