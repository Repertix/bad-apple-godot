extends Control

func read_pgm_p5(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Could not open PGM file")
		return {}
	
	# Read magic number (e.g., "P5")
	var magic = _read_ascii_line(file)
	if magic != "P5":
		push_error("Not a valid P5 PGM file")
		return {}
	
	# Read lines, skipping comments and gathering width, height, and maxval
	var width = 0
	var height = 0
	var maxval = 0
	while not file.eof_reached():
		var line = _read_ascii_line(file)
		if line.begins_with("#") or line == "":
			continue
	
		var tokens = line.split(" ", false)
		if width == 0 and tokens.size() >= 2:
			width = int(tokens[0])
			height = int(tokens[1])
		elif maxval == 0 and tokens.size() >= 1:
			maxval = int(tokens[0])
			break

	if width == 0 or height == 0 or maxval == 0:
		push_error("Invalid or incomplete PGM header")
		return {}
	
	if maxval > 255:
		push_error("Only 8-bit PGM (maxval <= 255) is supported")
		return {}
	
	# Binary pixel data follows
	var total_pixels = width * height
	var pixels = file.get_buffer(total_pixels)
	
	if pixels.size() != total_pixels:
		push_error("Unexpected end of pixel data")

	return {
		"width": width,
		"height": height,
		"maxval": maxval,
		"pixels": pixels
	}

func _read_ascii_line(file: FileAccess) -> String:
	var line = ""
	while not file.eof_reached():
		var byte = file.get_8()
		if byte == 10:
			break
		line += char(byte)
	return line.strip_edges()

func _get_ascii(char:int) -> String:
	return "■" if char > 128 else "□"

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	$AudioStreamPlayer.play()
	for fr in range(6573):
		var frame_data = read_pgm_p5("res://frames_8040/frame"+str(fr + 1)+".pgm")
		var previous_pixels:PackedByteArray
		
		if frame_data.pixels.hex_encode() != previous_pixels.hex_encode():
			for y in range(frame_data.height):
				var line = ""
				 #This should optimize just a bit...
				for x in range(frame_data.width):
					var index = y * frame_data.width + x
					var value = frame_data.pixels[index]
					line += _get_ascii(value)
				print_rich(line)
			previous_pixels = frame_data.pixels
		await get_tree().create_timer(0.028).timeout #29-33 FPS
