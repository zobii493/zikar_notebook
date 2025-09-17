import 'package:flutter/material.dart';
import 'ismezat_kalmasharif.dart';

class NoteBook extends StatelessWidget {
  const NoteBook({super.key});

  @override
  Widget build(BuildContext context) {
    return IsmezatAndkalmaSarif(
        title: 'اسم ذات اللہ',
        subtitle: 'ALLAH',
        collectionName: 'IsmeZatData',
        historyCollection: 'ismezatzikarHistory');
  }
}

