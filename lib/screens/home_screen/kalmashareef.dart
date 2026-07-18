import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/ismezat_kalmasharif_provider.dart';
import 'ismezat_kalmasharif.dart';

class Kalmashareef extends StatelessWidget {
  const Kalmashareef({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IsmezatProvider(),
      child: const IsmezatAndkalmaSarif(
        title: 'لَا إِلٰهَ إِلَّا الله',
        subtitle: 'Kalma Sharif',
        collectionName: 'KalmaSharifData',
        historyCollection: 'kalmasharifHistory',
      ),
    );
  }
}