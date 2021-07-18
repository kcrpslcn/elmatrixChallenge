part of 'image_bloc.dart';

@freezed
abstract class ImageState with _$ImageState {
  const factory ImageState.initial() = Initial;
  const factory ImageState.noImage() = NoImage;
  const factory ImageState.imagePicked(File image) = ImagePicked;
  const factory ImageState.imageUploadFailed(
      RecipeFailure failure, Recipe recipe) = ImageUploadFailed;
  const factory ImageState.imageUploading() = ImageUploading;
  const factory ImageState.imageUploaded(String uri, Recipe recipe) =
      ImageUploaded;
}
