import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vp9_database/controllers/contact_db_controller.dart';
import 'package:vp9_database/models/contact.dart';

class ContactGetxController extends GetxController {
  RxList<Contact> contacts = <Contact>[].obs;
  final ContactDbController _contactDbController = ContactDbController();

  static ContactGetxController get to => Get.find<ContactGetxController>();

  @override
  void onInit() {
    readContact();
    super.onInit();
  }

  Future<void> readContact() async {
    contacts.value = await _contactDbController.read();
    //notifyListeners();
    //update();
  }

  Future<bool> createContact({required Contact contact}) async {
    int newRowId = await _contactDbController.create(contact);
    if (newRowId != 0) {
      contact.id = newRowId;
      contacts.add(contact);
      //notifyListeners();
      //update();
    }
    return newRowId != 0;
  }

  Future<bool> deleteContact(int id) async {
    bool deleted = await _contactDbController.delete(id);
    if (deleted) {
      contacts.removeWhere((element) => element.id == id);
      //notifyListeners();
      //update();
    }
    return deleted;
  }

  Future<bool> updateContact({required Contact contact}) async {
    bool updated = await _contactDbController.update(contact);
    if (updated) {
      int index = contacts.indexWhere((element) => element.id == contact.id);
      if (index != -1) {
        contacts[index] = contact;
        //notifyListeners();
        // update();
      }
    }
    return updated;
  }
}
