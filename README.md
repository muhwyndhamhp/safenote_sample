# safenote

Simple note taking app as a Flutter sample project. Built between May 25th - May 29th 2020 as of initial commit. This app represent several essential stuff for developing Flutter apps, such as:

- Local database (sqflite)
- REST API Crud (Get, Post, Patch) and Synchronization (via Airtable)
- File IO from local storage (path, path_provider, json file)
- Data model and JSON serialization, including parsing nested JSON
- Basic 3rd party plugins integration (Zefyr, SqfLite, http, etc)
- UI stack and routing, including argument passing between screens / route (but simple stuff wihout architecture such as BLoC / Provider)
- and many more

## Things to Note
This is sample app, built for the purpose of researching how versatile Flutter for app development. As such, this project has many holes that both purposefully left there and/or yet implemented properly, such as :
- Architectural Component (BLoC or similar)
- Many unused code that leftover from earlier builds (the project scope just keeps increasing as time goes, sorry!)
- Not allowing user to save the Note without internet for the first time (yet to implement background service to upload the notes).
- No security concerns is addressed. anything is just as bare as it is.
- Build for Android-first experience
- Uncommented code!! yes, I'm sorry!!

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
