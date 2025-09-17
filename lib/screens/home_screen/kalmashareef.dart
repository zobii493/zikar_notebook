import 'package:flutter/material.dart';
import 'ismezat_kalmasharif.dart';

class Kalmashareef extends StatefulWidget {
  const Kalmashareef({super.key});

  @override
  State<Kalmashareef> createState() => _KalmashareefState();
}

class _KalmashareefState extends State<Kalmashareef> {
  @override
  Widget build(BuildContext context) {
    return IsmezatAndkalmaSarif(
        title: 'لَا إِلٰهَ إِلَّا الله',
        subtitle: 'Kalma Sharif',
        collectionName: 'KalmaSharifData',
        historyCollection: 'kalmasharifHistory');
  }
}


