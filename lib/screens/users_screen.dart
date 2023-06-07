import 'package:fake_store/model/users_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_handler.dart';
import '../widgets/users_widget.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Future<List<UsersModel>> getUsers() async {
    return ApiHandler.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: FutureBuilder<List<UsersModel>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // print(snapshot.hasData);
          // print(snapshot.hasError);
          // print(snapshot.data);
          if (snapshot.data == null) {
            return const Center(child: Text("No Users"));
          }
          List<UsersModel> usersList =snapshot.data!;

          return ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (ctx, index) {
              return ChangeNotifierProvider.value(
                value: usersList[index],
                child: const UsersWidget(),
              );
            },
          );
        },
      ),
    );
  }
}
