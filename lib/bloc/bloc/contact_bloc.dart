import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp9_database/bloc/events/crud_event.dart';
import 'package:vp9_database/bloc/states/crud_state.dart';
import 'package:vp9_database/controllers/contact_db_controller.dart';
import 'package:vp9_database/models/contact.dart';

class ContactBloc extends Bloc<CrudEvent, CrudState> {
  List<Contact> _contacts = <Contact>[];
  final ContactDbController _contactDbController = ContactDbController();

  ContactBloc(CrudState initialState) : super(initialState) {
    on<CreateEvent<Contact>>(_onCreateEvent);
    on<ReadEvent>(_onReadEvent);
    on<UpdateEvent<Contact>>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  void _onCreateEvent(CreateEvent<Contact> event, Emitter emit) async {
    int newRowId = await _contactDbController.create(event.newObject);
    if (newRowId != 0) {
      event.newObject.id = newRowId;
      _contacts.add(event.newObject);
      emit(ReadState(_contacts));
    }
    emit(ProcessState(Process.create, newRowId != 0,
        newRowId != 0 ? 'Created Successfully' : 'Create failed !'));
  }

  void _onReadEvent(ReadEvent event, Emitter emit) async {
    _contacts = await _contactDbController.read();
    emit(ReadState(_contacts));
  }

  void _onUpdateEvent(UpdateEvent<Contact> event, Emitter emit) async {
    bool updated = await _contactDbController.update(event.updatedObject);
    if (updated) {
      int index = _contacts
          .indexWhere((element) => element.id == event.updatedObject.id);
      if (index != -1) {
        _contacts[index] = event.updatedObject;
        emit(ReadState(_contacts));
      }
    }
    emit(ProcessState(Process.update, updated,
        updated ? 'Updated Successfully' : 'Update failed !'));
  }

  void _onDeleteEvent(DeleteEvent event, Emitter emit) async {
    bool deleted = await _contactDbController.delete(event.id);
    if (deleted) {
      _contacts.removeWhere((element) => element.id == event.id);
      emit(ReadState(_contacts));
    }
    emit(ProcessState(Process.delete, deleted,
        deleted ? 'Deleted Successfully' : 'Delete failed !'));
  }
}
