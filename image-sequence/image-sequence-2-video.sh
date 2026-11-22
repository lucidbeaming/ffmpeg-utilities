# Convert a sequence of images to a video, filling the frame and cropping to exactly 1920x1080, 3 frames per second, starting at filename with the number 26565 and working through all images with 5 digits of numbers in the filename

# Specifically, this converts a series of timelapse images made with a GoPro into a 1080p video of good quality


ffmpeg -r 3 -start_number 26565 -i G00%05d.JPG -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" -r 29.97 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset slow timelapse-video.mp4