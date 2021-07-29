import 'package:flutter/material.dart';
import 'package:flutter_app/page/model/task.dart';
import 'package:flutter_app/page/task_page/resources/task_data.dart';
import 'package:flutter_app/page/task_page/resources/task_requests.dart';

import '../../index.dart';

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
          return Consumer<List<Task?>>(
            providerKey: "TaskProviderKey",
            builder: (context, value) {
              return Column(
                children: [
                  ...List.generate(
                    value.length,
                    (index) => InkWell(
                      onTap: () {
                        if (!value[index]!.isFinish!)
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text("Confirm Task",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                            value[index]!.name!),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                            value[index]!.date!),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Fetch<Task?, TaskFetchParams>(
                                          request: setTaskFinished,
                                          lazy: true,
                                          onSuccess: (value) {
                                            (Provider.providers[
                                                        "TaskProviderKey"]
                                                    as List<Task>)[index]
                                                .isFinish = true;
                                            var callbacks = Provider.callbacks
                                                .where((element) =>
                                                    element.providerKey ==
                                                    "TaskProviderKey");

                                            for (var callback in callbacks) {
                                              callback.callbackFunc(
                                                  Provider.providers[
                                                      "TaskProviderKey"]);
                                            }
                                            Navigator.pop(context);
                                          },
//                                      params: TaskFetchParams(body: Task(id: fetchState.response![index]!.id,isFinish: true,)),
                                          builder: (fetchStateButton) {
                                            return Stack(
                                              children: [
                                                TextButton(
                                                  child: Center(
                                                      child: Text(
                                                    "Complete",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12),
                                                  )),
                                                  onPressed: () {
                                                    fetchStateButton.fetch(
                                                        TaskFetchParams(
                                                            body: Task(
                                                                id: value[
                                                                        index]!
                                                                    .id,
                                                                isFinish: true,
                                                                time: value[
                                                                        index]!
                                                                    .time,
                                                                name: value[
                                                                        index]!
                                                                    .name,
                                                                date: value[
                                                                        index]!
                                                                    .date,
                                                                desc:value[
                                                                        index]!
                                                                    .desc)));
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .deepOrange)),
                                                ),
                                                if (fetchStateButton.loading ==
                                                    true)
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.deepOrange,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              value[index]!.isFinish == true
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            SizedBox(
                              width: 28,
                            ),
                            Expanded(
                              child: Text(value[index]!.name!),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Fetch<Task?, TaskFetchParams>(
                              request: deleteTask,
                              lazy: true,
                              onSuccess: (task) {
                                (Provider.providers["TaskProviderKey"]
                                        as List<Task>)
                                    .removeAt(index);
                                var callbacks = Provider.callbacks.where(
                                    (element) =>
                                        element.providerKey ==
                                        "TaskProviderKey");

                                for (var callback in callbacks) {
                                  callback.callbackFunc(
                                      Provider.providers["TaskProviderKey"]);
                                }
                              },
                              builder: (fetchStateButton) {
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        fetchStateButton.fetch(
                                          TaskFetchParams(
                                            body: Task(
                                              id: value[index]!.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                    ),
                                    if (fetchStateButton.loading == true)
                                      Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.deepOrange,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );

//    return Text(fetchState.response!, textDirection: TextDirection.ltr);
  }
}
