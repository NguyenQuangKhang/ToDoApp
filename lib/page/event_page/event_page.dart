import 'package:flutter/material.dart';
import 'package:flutter_app/page/event_page/widgets/custom_icon_decoration.dart';
import 'package:flutter_app/page/model/task.dart';
import 'package:flutter_app/page/task_page/resources/task_data.dart';
import 'package:flutter_app/page/task_page/resources/task_requests.dart';
import 'package:intl/intl.dart';
import '../../consumer.dart';
import '../../fetch.dart';
import '../../provider.dart';

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Task> _eventList = Provider.providers["TaskProviderKey"];

    _eventList.sort((a, b) => (DateFormat("HH:mm")
            .format(DateTime.parse(a.time!))
            .toString())
        .compareTo(
            DateFormat("HH:mm").format(DateTime.parse(b.time!)).toString()));

    return Consumer<List<Task>>(
      providerKey: "TaskProviderKey",
      builder: (context, value) {
        return ListView.builder(
          itemCount: _eventList.length,
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24),
              child: Row(
                children: <Widget>[
                  _lineStyle(context, 20, index, _eventList.length,
                      _eventList[index].isFinish!),
                  _displayTime(DateFormat("HH:mm")
                      .format(DateTime.parse(_eventList[index].time!))
                      .toString()),
                  _displayContent(_eventList[index])
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _displayContent(Task event) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.name!),
              SizedBox(
                height: 12,
              ),
              Text(event.desc!)
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayTime(String time) {
    return Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(time),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
        decoration: CustomIconDecoration(
            iconSize: iconSize,
            lineWidth: 1,
            firstData: index == 0 ? true : false,
            lastData: index == listLength - 1 ? true : false),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.redAccent.withOpacity(0.1),
                  blurRadius: 3,
                  spreadRadius: 1)
            ],
          ),
          child: Icon(
              isFinish
                  ? Icons.fiber_manual_record
                  : Icons.radio_button_unchecked,
              size: iconSize,
              color: Colors.redAccent),
        ));
  }
}
