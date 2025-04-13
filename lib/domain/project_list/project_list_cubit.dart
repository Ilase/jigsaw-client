import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'project_list_state.dart';

class ProjectListCubit extends Cubit<ProjectListState> {
  ProjectListCubit() : super(ProjectListInitial());
}
