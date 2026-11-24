# Related tools

The scripts in this folder wrap tools that aren't part of ffmpeg itself and need their own install: primitive, which redraws an image as an SVG built from simple shapes, and videogrep, which transcribes speech and joins every moment a word is spoken into a supercut. Reach for them when ffmpeg alone can't do the job but can handle the steps around it, such as extracting frames before a redraw and reassembling them afterwards, or slowing down, jittering or crushing a finished supercut. Neither script was tested here, so check the header of each for install steps and what every flag does before adapting it.

