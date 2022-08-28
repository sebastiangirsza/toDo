part of 'home_cubit.dart';

@immutable
class HomeState {
  final List<QueryDocumentSnapshot<Object?>> documents;
  final bool isLoading;
  final String errorMessage;

  HomeState({
    required this.documents,
    required this.isLoading,
    required this.errorMessage,
  });
}
