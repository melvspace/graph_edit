import 'package:example/examples/item_builder/item_builder_page.dart';
import 'package:example/versions/canvas_page.dart';
import 'package:example/versions/connections_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter router;

  @override
  void initState() {
    router = GoRouter(
      initialLocation: '/canvas',
      routes: [
        GoRoute(
          path: '/canvas',
          builder: (context, state) => CanvasPage(),
        ),
        GoRoute(
          path: '/connections',
          builder: (context, state) => ConnectionsPage(),
        ),
        GoRoute(
          path: '/item-builder',
          builder: (context, state) => ItemBuilderPage(),
        ),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Drawer>(
      create: (context) => Drawer(
        child: Column(
          children: [
            ListTile(
              title: Text('V2'),
              onTap: () => router.go('/v2'),
            ),
            ListTile(
              title: Text('Connections'),
              onTap: () => router.go('/connections'),
            ),
            ListTile(
              title: Text('Item Builder'),
              onTap: () => router.go('/item-builder'),
            ),
          ],
        ),
      ),
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData.dark(),
      ),
    );
  }
}
