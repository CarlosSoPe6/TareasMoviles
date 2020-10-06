part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetAllUsersEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class FilterUsersEvent extends HomeEvent {
  final bool filterEven;

  FilterUsersEvent({@required this.filterEven}); // filtrar pares

  @override
  List<Object> get props => [filterEven];
}
