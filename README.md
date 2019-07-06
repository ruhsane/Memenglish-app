# Memenglish

## Description
Learn English With Memes! The app automatically detects the text in the meme image, and translates into the language chosen.

## Technologies
FirebaseMLVision Framework to recognize text in image
Google translation API
Grand Central Dispatch

## Integration with Grand Central Dispatch
Old version: had to download every meme image, detect texts and translate the text before showing the view to the user.
New version(after integrating Dispatch): shows view on the main queue instantly. Then downloads, detects, translates in other threads with .background qos level, updates the UI when it's done. Gives much more smooth user experience and performance.
