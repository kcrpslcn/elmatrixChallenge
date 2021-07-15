import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipes_repository/recipes_repository.dart';

part 'image_bloc.freezed.dart';
part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final RecipesRepository _recipesRepository;

  ImageBloc({required RecipesRepository recipesRepository})
      : _recipesRepository = recipesRepository,
        super(ImageState.initial());

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    yield* event.map(
      pickImage: (event) async* {
        yield ImagePicked(event.image);
      },
      uploadImage: (event) async* {
        yield ImageUploading();
        final uri = await _recipesRepository.uploadImage(event.image);
        yield ImageUploaded(uri);
      },
      loadFromUri: (event) async* {
        yield ImageUploaded(event.uri);
      },
    );
  }
}
