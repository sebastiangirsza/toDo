import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(HomeState(
          documents: [],
          errorMessage: '',
          isLoading: false,
        ));

  Future<void> delete({required String document}) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(document)
        .delete();
  }

  Future<void> add({
    required String controller,
  }) async {
    FirebaseFirestore.instance.collection('categories').add({
      'title': controller,
    });
  }

  StreamSubscription? _streamSubscription;

  Future<void> start() async {
    HomeState(
      documents: [],
      errorMessage: '',
      isLoading: true,
    );
    _streamSubscription = FirebaseFirestore.instance
        .collection("categories")
        .snapshots()
        .listen((data) {
      emit(
        HomeState(
          documents: data.docs,
          isLoading: false,
          errorMessage: '',
        ),
      );
    })
      ..onError((error) {
        emit(
          HomeState(
            documents: const [],
            isLoading: false,
            errorMessage: error.toString(),
          ),
        );
      });
  }
}
