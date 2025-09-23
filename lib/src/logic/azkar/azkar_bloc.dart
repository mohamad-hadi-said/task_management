import 'package:task_management/core/cache/app_cache.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/src/logic/azkar/azkar_state.dart';
import 'package:task_management/src/model/azkar_model.dart';

part 'azkar_event.dart';

enum AzkarType { morning, evening, general }

class AzkarBloc extends Bloc<AzkarEvent, AzkarState> {
  final AzkarType azkarType;
  AzkarBloc({required this.azkarType}) : super(AzkarState()) {
    on<LoadAzkar>(_onLoadAzkar);
    on<IncrementCount>(_onIncrementCount);
    on<DecrementCount>(_onDecrementCount);
    on<NextAzkar>(_onNextAzkar);
    on<PrevAzkar>(_onPrevAzkar);
    on<ResetCurrent>(_onResetCurrent);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadAzkar(LoadAzkar event, Emitter<AzkarState> emit) async {
    emit(state.copyWith(loading: true, error: false));

    // Read all azkar from cache
    final allAzkar = _readAllFromCache();
    if (allAzkar.isEmpty) {
      emit(
        state.copyWith(
          loading: false,
          error: true,
          errorMessage: 'لا توجد أذكار متاحة',
        ),
      );
      return;
    }

    // Filter by current screen/type
    final filtered = _filterByType(allAzkar, azkarType);
    if (filtered.isEmpty) {
      emit(
        state.copyWith(
          loading: false,
          error: true,
          errorMessage: 'لا توجد أذكار اليوم',
        ),
      );
      return;
    }

    // Sort and set initial state
    final sorted = sortAzkar(filtered);
    emit(
      state.copyWith(
        loading: false,
        error: false,
        azkar: sorted,
        currentZeker: sorted.first,
        currentCount: 0,
      ),
    );
  }

  List<AzkarModel> sortAzkar(List<AzkarModel> azkar) {
    final withOrder = azkar.where((e) => e.order != null).toList()
      ..sort((a, b) => a.order!.compareTo(b.order!));
    final withoutOrder = azkar.where((e) => e.order == null).toList();
    return [...withOrder, ...withoutOrder];
  }

  // --- Helpers ---
  List<AzkarModel> _readAllFromCache() {
    return AppCache.instance.getAzkar();
  }

  List<AzkarModel> _filterByType(List<AzkarModel> list, AzkarType type) {
    return list.where((e) => e.type == type.index).toList();
  }

  Future<void> _onIncrementCount(
    IncrementCount event,
    Emitter<AzkarState> emit,
  ) async {
    final current = state.currentZeker;
    if (current == null) return;
    final maxRep = (current.repetitions ?? 1);
    final next = state.currentCount + 1;
    emit(state.copyWith(currentCount: next > maxRep ? maxRep : next));
  }

  Future<void> _onDecrementCount(
    DecrementCount event,
    Emitter<AzkarState> emit,
  ) async {
    final next = state.currentCount - 1;
    emit(state.copyWith(currentCount: next < 0 ? 0 : next));
  }

  Future<void> _onResetCurrent(
    ResetCurrent event,
    Emitter<AzkarState> emit,
  ) async {
    emit(state.copyWith(currentCount: 0));
  }

  Future<void> _onNextAzkar(NextAzkar event, Emitter<AzkarState> emit) async {
    if (state.azkar.isEmpty) return;
    final idx = state.currentZeker == null
        ? -1
        : state.azkar.indexOf(state.currentZeker!);
    final nextIndex = idx + 1;
    if (nextIndex >= 0 && nextIndex < state.azkar.length) {
      emit(
        state.copyWith(currentZeker: state.azkar[nextIndex], currentCount: 0),
      );
    }
  }

  Future<void> _onPrevAzkar(PrevAzkar event, Emitter<AzkarState> emit) async {
    if (state.azkar.isEmpty) return;
    final idx = state.currentZeker == null
        ? 0
        : state.azkar.indexOf(state.currentZeker!);
    final prevIndex = idx - 1;
    if (prevIndex >= 0 && prevIndex < state.azkar.length) {
      emit(
        state.copyWith(currentZeker: state.azkar[prevIndex], currentCount: 0),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<AzkarState> emit,
  ) async {
    final current = state.currentZeker;
    if (current == null) return;
    final updated = AzkarModel(
      id: current.id,
      text: current.text,
      repetitions: current.repetitions,
      order: current.order,
      isFavorite: !(current.isFavorite ?? false),
    );
    final list = List<AzkarModel>.from(state.azkar);
    final idx = list.indexWhere((e) => e.id == current.id);
    if (idx != -1) list[idx] = updated;
    emit(
      state.copyWith(
        azkar: list,
        currentZeker: updated,
        currentCount: state.currentCount,
      ),
    );
  }
}
