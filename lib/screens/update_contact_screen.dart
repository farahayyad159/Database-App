import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp9_database/bloc/bloc/contact_bloc.dart';
import 'package:vp9_database/bloc/events/crud_event.dart';
import 'package:vp9_database/bloc/states/crud_state.dart';
import 'package:vp9_database/get/contact_getx_controller.dart';
import 'package:vp9_database/models/contact.dart';
import 'package:vp9_database/utils/helpers.dart';
import 'package:vp9_database/widgets/contact_textfield.dart';

class UpdateContactScreen extends StatefulWidget {
  UpdateContactScreen({required this.contact, Key? key}) : super(key: key);

  final Contact contact;

  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

late TextEditingController _nameTextController;
late TextEditingController _phoneTextController;

class _UpdateContactScreenState extends State<UpdateContactScreen>
    with Helpers {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTextController = TextEditingController(text: widget.contact.name);
    _phoneTextController = TextEditingController(text: widget.contact.phone);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameTextController.dispose();
    _phoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact'),
      ),
      body: BlocListener<ContactBloc, CrudState>(
        listener:(context, state) {
          if(state is ProcessState && state.process == Process.update){
            showSnackBar(context: context, message: state.message, error: !state.status);
          }
        },
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          children: [
            const Text('Welcome...'),
            const SizedBox(
              height: 20,
            ),
            ContactTextField(
              controller: _nameTextController,
              prefixIcon: Icons.contacts,
              keyboardType: TextInputType.text,
              label: 'Name',
            ),
            const SizedBox(
              height: 10,
            ),
            ContactTextField(
              controller: _phoneTextController,
              prefixIcon: Icons.phone_android,
              keyboardType: TextInputType.text,
              label: 'Phone',
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                performSave();
              },
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
              ),
            )
          ],
        ),
      ),
    );
  }

  void performSave() {
    if (checkData()) {
      update();
    }
  }

  bool checkData() {
    if (_nameTextController.text.isNotEmpty &&
        _phoneTextController.text.isNotEmpty) {
      return true;
    } else {
      showSnackBar(context: context, message: 'Update Failed', error: true);
      return false;
    }
  }

  void update() {
    //PROVIDER
    // bool updated = await Provider.of<ContactProvider>(context, listen: false)
    //     .update(contact: contact);
    //GET
    // bool updated = await ContactGetxController.to.updateContact(contact: contact);
    // if (updated) {
    //   showSnackBar(context: context, message: 'Updated Successfully', error: !updated);
    //   Navigator.pop(context);
    // }
    BlocProvider.of<ContactBloc>(context).add(UpdateEvent(contact));
    Navigator.pop(context);
  }

  Contact get contact {
    Contact contact = Contact();
    contact = widget.contact;
    contact.name = _nameTextController.text;
    contact.phone = _phoneTextController.text;
    return contact;
  }
}
