enum Process { create, update, delete }

abstract class CrudState {}

class LoadingState extends CrudState {}

class ProcessState extends CrudState {
  Process process;
  bool status;
  String message;

  ProcessState(this.process, this.status, this.message);
}

class ReadState<T> extends CrudState {
  List<T> list;

  ReadState(this.list);
}

class ErrorState extends CrudState {
  String message;

  ErrorState(this.message);
}
