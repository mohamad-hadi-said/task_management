part of 'azkar_bloc.dart';

abstract class AzkarEvent extends Equatable {
  const AzkarEvent();

  @override
  List<Object> get props => [];
}

class LoadAzkar extends AzkarEvent {
  const LoadAzkar();
}

class IncrementCount extends AzkarEvent {
  const IncrementCount();
}

class DecrementCount extends AzkarEvent {
  const DecrementCount();
}

class NextAzkar extends AzkarEvent {
  const NextAzkar();
}

class PrevAzkar extends AzkarEvent {
  const PrevAzkar();
}

class ResetCurrent extends AzkarEvent {
  const ResetCurrent();
}

class ToggleFavorite extends AzkarEvent {
  const ToggleFavorite();
}
