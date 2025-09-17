import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../provider/fezunoor_provider.dart';

class FezuNoor extends StatelessWidget {
  const FezuNoor({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FezuNoorProvider>(context);
    double progress = provider.calculateProgress();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'فیوض النور',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
          onPressed: () {
            provider.saveProgressBar(progress);
            Navigator.of(context).pop(progress);
          },
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical,
                color: Colors.white),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    child: const Text('Undo'),
                    onTap: () =>
                        Future.delayed(Duration.zero, () => provider.undoLastTask()),
                  ),
                  PopupMenuItem(
                    value: 'history',
                    child: const Text('history'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Text('Delete All Completed Tasks'),
                  ),
                ],
              ).then((value) async {
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Confirmation"),
                      content: const Text("Are you sure you want to delete all completed tasks?"),
                      actions: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: TextButton(
                            onPressed: () {
                              provider.removeAllCompleted();
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("Yes, Delete",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (value == 'history') {
                  final history = await provider.getCompletionHistory();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Completion history"),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: history.length,
                          itemBuilder: (_, i) => ListTile(
                            title: Text(history[i]["label"]),
                            subtitle: Text(
                                "${history[i]["day"]}, ${history[i]["date"]} at ${history[i]["time"]}"),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              });
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: List.generate(provider.checkboxLabels.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                      value: provider.isCheckedList[index],
                      onChanged: provider.isCheckedList[index]
                          ? null
                          : (_) => provider.completeTaskWithDialog(
                          context, index),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            provider.checkboxLabels[index],
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black45),
                          height: 25,
                          width: 25,
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
