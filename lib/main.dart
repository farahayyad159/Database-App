import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vp9_database/bloc/bloc/contact_bloc.dart';
import 'package:vp9_database/bloc/states/crud_state.dart';
import 'package:vp9_database/database/db_controller.dart';
import 'package:vp9_database/providers/contact_provider.dart';
import 'package:vp9_database/screens/create_contact_screen.dart';
import 'package:vp9_database/screens/launch_screen.dart';
import 'package:vp9_database/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContactBloc>(create: (context) => ContactBloc(LoadingState())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/launch_screen',
        routes: {
          '/launch_screen': (context) => const LaunchScreen(),
          '/main_screen': (context) => const MainScreen(),
          '/create_contact_screen': (context) => const CreateContactScreen(),
        },
      ),
    );
  }
}
