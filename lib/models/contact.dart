class Contact {
  late int id;
  late String name;
  late String phone;

  Contact();

  Contact.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap['id'];
    name = rowMap['name'];
    phone = rowMap['phone'];
  }

  Map<String,dynamic> toMap() {
    Map<String,dynamic> rowMap = <String,dynamic> {};
    rowMap['name'] = name;
    rowMap['phone'] = phone;
    return rowMap;
  }

}
