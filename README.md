# Niclas elmatrix coding challenge

Flutter code challenge for my application at elmatrix.

## Building the app
Info: `The app is tested only on a physical android device. There was some testing done on a virtual android device.`

In order to build the app, `build_runner` has to be run with `flutter pub run build_runner build` for all packages (`main`, `user_repository`, `recipe_repository`). For more information see [build_runner](https://pub.dev/packages/build_runner).

### Contact information 
Niclas Prock
niclasprock@gmail.com
0177 / 758 90 57

#### Infos
    The google-services.json is included for this project.

    Total cooking sessions considers only active recipes! There is no deleted flag or something similar.

#### Known Bugs
    If you upload an image and leave the details screen immediately, the image will not be saved. This is due to the BlocListener not being triggered, because the Widget is already destroyed.