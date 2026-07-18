import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/ismezat_kalmasharif_provider.dart';
import 'ismezat_kalmasharif.dart';

class NoteBook extends StatelessWidget {
  const NoteBook({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IsmezatProvider(),
      child: const IsmezatAndkalmaSarif(
        title: 'اسم ذات اللہ',
        subtitle: 'ALLAH',
        collectionName: 'IsmeZatData',
        historyCollection: 'ismezatzikarHistory',
      ),
    );
  }
}