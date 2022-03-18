import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vp9_database/bloc/bloc/contact_bloc.dart';
import 'package:vp9_database/bloc/events/crud_event.dart';
import 'package:vp9_database/bloc/states/crud_state.dart';
import 'package:vp9_database/get/contact_getx_controller.dart';
import 'package:vp9_database/models/contact.dart';
import 'package:vp9_database/providers/contact_provider.dart';
import 'package:vp9_database/screens/update_contact_screen.dart';
import 'package:vp9_database/utils/helpers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with Helpers {
  @override
  void initState() {
    //Provider.of<ContactProvider>(context, listen: false).read();
    BlocProvider.of<ContactBloc>(context).add(ReadEvent());
    super.initState();
  }

  // final ContactGetxController _contactGetxController =
  //     Get.put<ContactGetxController>(ContactGetxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create_contact_screen');
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocConsumer<ContactBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState && current.process == Process.delete,
        listener: (context, state) {
          showSnackBar(
              context: context, message: (state as ProcessState).message, error: !state.status);
        },
        buildWhen: (previous, current) =>
            current is LoadingState || current is ReadState<Contact>,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReadState<Contact> && state.list.isNotEmpty) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateContactScreen(
                          contact: state.list[index],
                        ),
                      ),
                    );
                  },
                  leading: const Icon(Icons.contacts),
                  title: Text(state.list[index].name),
                  subtitle: Text(state.list[index].phone),
                  trailing: IconButton(
                    onPressed: () {
                      delete(state.list[index].id);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.warning,
                    size: 90,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'NO DATA',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      // body: Obx(() {
      //   if (ContactGetxController.to.contacts.isNotEmpty) {
      //     return ListView.builder(
      //       itemCount: ContactGetxController.to.contacts.length,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           onTap: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => UpdateContactScreen(
      //                   contact: ContactGetxController.to.contacts[index],
      //                 ),
      //               ),
      //             );
      //           },
      //           leading: const Icon(Icons.contacts),
      //           title: Text(ContactGetxController.to.contacts[index].name),
      //           subtitle: Text(ContactGetxController.to.contacts[index].phone),
      //           trailing: IconButton(
      //             onPressed: () async {
      //               await delete(ContactGetxController.to.contacts[index].id);
      //             },
      //             icon: const Icon(
      //               Icons.close,
      //               color: Colors.red,
      //               size: 28,
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   } else {
      //     return Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: const [
      //           Icon(
      //             Icons.warning,
      //             size: 90,
      //             color: Colors.grey,
      //           ),
      //           SizedBox(
      //             height: 15,
      //           ),
      //           Text(
      //             'NO DATA',
      //             style: TextStyle(
      //               fontSize: 30,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.grey,
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // }),
    );
  }

  void delete(int id) {
    //PROVIDER
    // bool deleted =
    //     await Provider.of<ContactProvider>(context, listen: false).delete(id);
    // GET
    // bool deleted = await ContactGetxController.to.deleteContact(id);
    // if (deleted) {
    //   String message = deleted ? 'Deleted successfully' : 'Delete failed';
    //   showSnackBar(context: context, message: message, error: !deleted);
    // }
    BlocProvider.of<ContactBloc>(context).add(DeleteEvent(id));
  }
}
