import 'package:flutter/material.dart';
import 'package:pest_detection/providers/local_provider.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import 'widgets/plant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 130.0,
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () {
                    final newLocale =
                        localeProvider.locale.languageCode == 'en'
                            ? const Locale('hi')
                            : const Locale('en');
                    localeProvider.setLocale(newLocale);
                  },
                  icon: Icon(
                    Icons.language,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                SizedBox(width: 10),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  localeProvider.get('appTitle'),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(color: AppTheme.backgroundColor),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localeProvider.get('welcome'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      localeProvider.get('selectPlant'),
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PlantCard(plant: plants[index]),
                  childCount: plants.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}