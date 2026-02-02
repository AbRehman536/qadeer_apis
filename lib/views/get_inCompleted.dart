import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qadeer_apis/models/taskListing.dart';
import 'package:qadeer_apis/services/task.dart';
import 'package:qadeer_apis/views/create_task.dart';
import 'package:qadeer_apis/views/get_profile.dart';
import 'package:qadeer_apis/views/update_task.dart';

import '../provider/user_token.dart';

class GetInCompletedTask extends StatelessWidget {
  const GetInCompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get InCompleted Task"),
      ),
      body: FutureProvider.value(
        value: TaskServices().getInCompletedTask(userProvider.getToken().toString()),
        initialData: [TaskListingModel()],builder: (context,child){
        TaskListingModel taskListingModel = context.watch<TaskListingModel>();
        if(taskListingModel.tasks == null){
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.task),
            title: Text(taskListingModel.tasks![index].description.toString()),

          );
        },);
      },),
    );
  }
}
