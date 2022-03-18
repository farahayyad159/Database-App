import 'package:flutter/cupertino.dart';
import 'package:vp9_database/controllers/contact_db_controller.dart';
import 'package:vp9_database/models/contact.dart';

class ContactProvider extends ChangeNotifier {

  List<Contact> contacts = <Contact>[];
  final ContactDbController _contactDbController = ContactDbController();


  Future<void> read() async {
    contacts = await _contactDbController.read();
    notifyListeners();
  }

  Future<bool> create({required Contact contact}) async {
    int newRowId = await _contactDbController.create(contact);
    if (newRowId != 0) {
      contact.id = newRowId;
      contacts.add(contact);
      notifyListeners();
    }
    return newRowId != 0;
  }

  Future<bool> delete(int id) async {
    bool deleted = await _contactDbController.delete(id);
    if (deleted) {
      contacts.removeWhere((element) => element.id == id);
      notifyListeners();
    }
    return deleted;
  }

  Future<bool> update({required Contact contact}) async {
    bool updated = await _contactDbController.update(contact);
    if (updated) {
      int index = contacts.indexWhere((element) => element.id == contact.id);
      if (index != -1) {
        contacts[index] = contact;
        notifyListeners();
      }
    }
    return updated;
  }

}