import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigsaw_client/core/data_repository.dart';

abstract class DataEvent {}

class LoadAllData extends DataEvent {}

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List users;
  final List projects;
  DataLoaded(this.users, this.projects);
}

class DataError extends DataState {
  final String message;
  DataError(this.message);
}

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepository repo;

  DataBloc(this.repo) : super(DataInitial()) {
    on<LoadAllData>((event, emit) async {
      emit(DataLoading());
      try {
        final users = await repo.fetchUsers();
        final projects = await repo.fetchProjects();
        emit(DataLoaded(users, projects));
      } catch (e) {
        emit(DataError(e.toString()));
      }
    });
  }
}
