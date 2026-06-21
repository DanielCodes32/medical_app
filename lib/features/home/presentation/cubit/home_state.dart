class HomeState {}

class InitalHomeState extends HomeState {}

class LoadingHomeState extends HomeState {}

class LoadingMoreHomeState extends HomeState {}

class SuccessHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  String? message;
  ErrorHomeState({required this.message});
}
