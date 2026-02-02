import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qadeer_apis/models/task.dart';
import 'package:qadeer_apis/services/task.dart';
import 'package:qadeer_apis/views/create_task.dart';
import 'package:qadeer_apis/views/get_completed.dart';
import 'package:qadeer_apis/views/get_inCompleted.dart';
import 'package:qadeer_apis/views/get_profile.dart';
import 'package:qadeer_apis/views/update_task.dart';

import '../models/taskListing.dart';
import '../provider/user_token.dart';

class GetAllTask extends StatelessWidget {
  const GetAllTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProfile()));
          }, icon: Icon(Icons.person)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetCompletedTask()));
          }, icon: Icon(Icons.circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetInCompletedTask()));
          }, icon: Icon(Icons.incomplete_circle)),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateTask()));
      },child: Icon(Icons.add),),
      body: FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
          initialData: [TaskListingModel()],builder: (context,child){
            TaskListingModel taskListingModel = context.watch<TaskListingModel>();
            if(taskListingModel.tasks == null){
              return Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
                trailing: Row(children: [
                  IconButton(onPressed: ()async{
                    try{
                      await TaskServices().deleteTask(
                          token: userProvider.getToken().toString(),
                          taskID: taskListingModel.tasks![index].id.toString())
                          .then((val){
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text("Deleted Successfully"),
                                actions: [TextButton(onPressed: (){}, child: Text("Okay"))],
                              );
                            });
                      });
                    }catch(e){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }, icon: Icon(Icons.delete)),
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateTask(model: taskListingModel.tasks[index].toString())));
                  }, icon: Icon(Icons.edit))
                ],)
              );
            },);
      },),
    );
  }
}
