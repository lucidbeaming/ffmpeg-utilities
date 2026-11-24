# Resize and crop

The scripts in this folder fit existing footage into a fixed output frame: most scale the source until it covers the target size and then crop the overflow, while the vertical Canvas script rotates landscape footage on its side and scales it to a 9:16 portrait frame. Reach for them when a player, projector, monitor or platform expects an exact resolution and you'd rather lose the edges of the picture than add black bars. Each re-encodes to widely compatible H.264, and the target size, frame rate and crop position are plain numbers in the command, so adapting one to another resolution is usually a matter of editing those values; the header explains each flag.

