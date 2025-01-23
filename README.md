# Flutter Object Detection App

Flutter Object Detection is a mobile application built using Flutter that detects objects using a TensorFlow Lite model. The app allows users to capture and classify objects, save them in a gallery. This project was developed for academic purposes as part of a university course project.

## Features

### Object Detection and Classification

- Opens the camera and detects objects using a TensorFlow Lite model.
- Allows the user to click a button to classify an object and hear its name spoken aloud.

### Gallery

- Saves captured images with their classified object names in a user-specific gallery.
- Displays the object name as a label alongside the image.
- Allows users to delete images from their gallery.
- Enables users to click a button in the gallery to hear the object name spoken aloud.

### User Authentication and Tutorials

- Provides a local storage-based login functionality to create and access personalized profiles.
- Includes a tutorial that guides users upon their first landing to help them understand the app features.

## Technology Stack

### Frameworks and Tools

- **Flutter**: Cross-platform mobile app development framework.
- **TensorFlow Lite**: Machine learning model for object classification.
- **Teachable Machine**: Tool for training the object detection model.

### Dependencies

- **Camera Package**: To access the device camera.
- **Text-to-Speech**: To announce the object name aloud.
- **Local Storage**: For saving images, metadata, and user profiles.

## How It Works

1. **Object Detection**
   - The app uses the TensorFlow Lite model trained via Teachable Machine to classify objects captured by the camera.
   - A button click triggers the detection and classification process.

2. **Gallery Management**
   - Images and their corresponding object labels are saved locally and managed using local storage.
   - Users can view, delete, or hear the object name for each saved image in the gallery.

3. **Authentication and Tutorials**
   - User data are stored locally, ensuring personalized collections on the device.
   - A tutorial is shown upon first login to introduce users to the app's features.

## Screenshots

| Camera Interface | Gallery  |
|-------------------|---------|
| ![Camera](https://github.com/hmdfrds/flutter-object-detection/blob/main/Camera.png) | ![Gallery](https://github.com/hmdfrds/flutter-object-detection/blob/main/Gallery.png)|

## Demonstration Video

[![Youtube](https://www.youtube.com/watch?v=EOIhXLSOczU/0.jpg)](https://www.youtube.com/watch?v=EOIhXLSOczU)

## License

This project is for academic purposes and is not intended for commercial use.

## Acknowledgments

- **Teachable Machine** for providing an easy-to-use platform for training the TensorFlow Lite model.
- **Flutter Community** for their helpful packages and documentation.
