import 'package:basicpos_v2/pages/master/pelanggan_cru.dart';
import 'package:basicpos_v2/pages/master/supplier.dart';
import 'package:basicpos_v2/pages/login.dart';
import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/dimens.dart' as dimens;
import 'constants/colors.dart' as colors;

Widget initialPage = LoginPage();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jaring Sales',
      // initialRoute: '/',
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        MainMenuPage.routeName: (context) => MainMenuPage(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:
            GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
          headline1: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: colors.textPrimary,
          ),
          headline2: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: colors.textPrimary,
          ),
          headline3: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
          headline4: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
          bodyText1: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colors.textPrimary,
          ),
          bodyText2: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colors.textPrimaryLight,
          ),
          subtitle1: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colors.subtitlePrimary,
          ),
          subtitle2: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colors.subtitlePrimary,
          ),
          button: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colors.buttonPrimaryText,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(colors.primary),
            overlayColor: MaterialStateProperty.all<Color>(colors.primaryLight),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dimens.bottomSheetBorderRadius),
                topRight: Radius.circular(dimens.bottomSheetBorderRadius)),
          ),
        ),
      ),
      home: initialPage,
      // initialRoute: '/login',
    );
  }
}
