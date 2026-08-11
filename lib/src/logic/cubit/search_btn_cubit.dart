import 'package:bloc/bloc.dart';

part 'search_btn_state.dart';

class SearchBtnCubit extends Cubit<SearchBtnState> {
  SearchBtnCubit() : super(SearchBtnState());

  void toggle() {
    emit(SearchBtnState(isToggled: state.isToggled ? false : true));
  }
}
