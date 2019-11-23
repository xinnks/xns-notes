import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xns_notes/services/XnsDatabase.dart';
import 'package:xns_notes/screens/FolderScreen/index.dart';
import 'screens/HomeScreen/index.dart';
import 'screens/NoteViewScreen/index.dart';

void main() { 
  runApp(
    ChangeNotifierProvider(
      builder: (context) => XnsDatabase(),
      child: XnsNotes(),
    )
  );
}

const Map<int, Color> PrimaryColorSwatch = {
  900: Color(0xFF49208F),
  800: Color(0xFF69289E),
  700: Color(0xFF7A2CA7),
  600: Color(0xFF8E32AF),
  500: Color(0xFF9C35B6),
  400: Color(0xFFAB50C1),
  300: Color(0xFFBA6FCD),
  200: Color(0xFFCE98DC),
  100: Color(0xFFE1C1E9),
  50: Color(0xFFF3E6F6),
};

final MaterialColor pSwatch = MaterialColor(0xFF49208F, PrimaryColorSwatch);

class XnsNotes extends StatelessWidget {
  // final appIndex = App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xns notes',
      theme: ThemeData(
        primarySwatch: pSwatch,
        primaryColor: Color(0xFF49208F),
        primaryColorLight: Color(0xFF6538AA),
        primaryColorDark: Color(0xFF2C0575),
        accentColor: Color(0xFFE8AF04),
        dividerColor: Color(0xFFA099A1),
        disabledColor: Color(0xFFB984FF),
        cardColor: Color(0xFFFFFFFF),
        primaryTextTheme: TextTheme(),
        accentTextTheme: TextTheme(),
        iconTheme: IconThemeData(),
        accentIconTheme: IconThemeData()
      ),
      // routes: appIndex.routes,
      onGenerateRoute: (RouteSettings settings) {
        final routes = <String, WidgetBuilder> {
          '/': (context) => HomeScreen(),
          FolderScreen.RouteName: (context) => FolderScreen(settings.arguments),
          NoteViewScreen.RouteName: (context) => NoteViewScreen(settings.arguments),
        };

        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}
