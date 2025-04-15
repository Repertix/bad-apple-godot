# Bad Apple in Godot
Boredness and free will makes the correct person do good stuff. This code plays Bad Apple frame-by-frame in Godot 4 output console, running between 29-33 FPS.

## Limitations
1. When reaching the amount of 100k messages in the console, it's possible Godot will start lagging and displaying the frames much slower, you can press on the "clear console" button and it will continue displaying normally.
2. To fix the "output overflow" error go to: `Project > Project Settings > Network > Limits` and set `Max Chars Per Second` to a high value

## Importing the project
1. Download the code
2. In Godot Project Manager click on Import
3. Search for the "project.godot" file in the project files
4. Import it and enjoy!

## "Installing the frames"
Due to the fact I can't import more than 100 files on the same time to GitHub, you're required to get the video frames by yourself, let me show you how.
### YOU REQUIRE FFMPEG INSTALLED ON YOUR COMPUTER!

1. In the project files create a folder called **frames_8040**
2. Download the original video as is and put it inside said folder.
3. With ffmpeg, use your preference command prompt interface (or just use Windows CMD) and execute the next code in the same folder:
```
ffmpeg -i [VIDEO_HERE: e.g. my_video.mp4] -vf scale=80:40,format=gray -pix_fmt gray -compression_level 0 frame%d.pgm
```
4. Let the process finish and you should be able to get the project running!

### It's important the frames are converted to PGM (P5 Format), otherwise it won't work!
