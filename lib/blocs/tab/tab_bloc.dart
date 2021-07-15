import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:elmatrix_niclas/models/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_bloc.freezed.dart';
part 'tab_event.dart';

class TabBloc extends Bloc<TabEvent, Tabs> {
  TabBloc() : super(Tabs.recipes);

  @override
  Stream<Tabs> mapEventToState(TabEvent event) async* {
    yield* event.map(pickImage: (event) async* {
      yield event.tab;
    });
  }
}
