part of 'image_bloc.dart';

@freezed
class ImageEvent with _$ImageEvent {
  const factory ImageEvent.pickImage(File image) = PickImage;
  const factory ImageEvent.uploadImage(File image, Recipe recipe) = UploadImage;
  const factory ImageEvent.loadFromUri(String? uri, Recipe recipe) =
      LoadFromUri;
}
