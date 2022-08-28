import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wydatki/app/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Do zrobienia',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: BlocProvider(
        create: (context) => HomeCubit(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return FloatingActionButton(
              backgroundColor: Colors.black12,
              onPressed: () {
                context.read<HomeCubit>().add(
                      controller: controller.text,
                    );
                controller.clear();
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => HomeCubit()..start(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              return const Text('Wystąpił nieoczekiwany problem');
            }

            if (state.isLoading) {
              return const Text('Proszę czekać trwa ładowanie danych');
            }

            final documents = state.documents;

            return ListView(
              children: [
                for (final document in documents) ...[
                  Dismissible(
                    key: ValueKey(document.id),
                    onDismissed: (_) {
                      context.read<HomeCubit>().delete(document: document.id);
                    },
                    child: CategoryWidget(
                      document['title'],
                    ),
                  ),
                ],
                TextField(
                  controller: controller,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      child: Text(title),
    );
  }
}
