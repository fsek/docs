.. _app-our-systems:

===========
Our Systems
===========

**Flutter**

Flutter is the UI kit we use for the app. It allows us to write using only standard elements called widgets, 
and then deploy the app to both IOS and Android at the same time with the click of a button (and usually a 
bit of work from the head of app dev.). 
Flutter uses Dart as the programming language for getting stuff done™.

**The Backend**

The app still points to the old backend, running Ruby on rails. Adding new things to the app that require changes to the backend is discouraged while we switch to the new, much simpler and better, backend.

When running and developing the app, ``stage.fsektionen.se`` will automatically be selected and you don't need to run the old backed on your own machine.

**Android Studio**

Android studio is most likely where you'll be installing the emulators for android needed to check if the app updates you write actually work. 

To get a new emulator up and running:

**VSCode**

Most app development happens in VSCode for the majority (2/2) of the active app developers. 
TODO: Check if Android Studio just works™. 

The following extensions might be useful:

- Dart 
- Flutter

**IOS Emulation**

Proper IOS emulation is in the works. For now you can simply disregard IOS emulation. Most changes in Flutter should work the same on IOS and android.