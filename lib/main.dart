import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'home_screen.dart';
import 'services/language_service.dart';

import 'login.dart';
import 'create_sale_form.dart';
import 'item_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final languageService = LanguageService();
  await languageService.initLanguage();
  
  runApp(MyProgram(languageService: languageService));
}

class MyProgram extends StatelessWidget {
  final LanguageService languageService;
  
  const MyProgram({super.key, required this.languageService});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageService>.value(
      value: languageService,
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Art Gallery App",
            locale: languageService.currentLocale,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[100], // Grey background for all pages
              primarySwatch: Colors.orange,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[100],
                elevation: 0,
              ),
            ),
            home: const CreateSaleForm(),
            // You can add routes here if needed
            // routes: {
            //   '/add-illustration': (context) => AddIllustrationForm(),
            // },
          );
        },
      ),
    );
  }
}