extends Node

enum STATUS {
	idle,
	create_component,
	create_line,
	simulation,
	select_save_area,
	move_component
	}


# 载入json设置文件
func get_from_json(path:String) -> Dictionary:
	var dic_json_result:Dictionary = {}
	var file = File.new()
	file.open(path, file.READ)
	var text:String = file.get_as_text()
	var json_result = JSON.parse(text)
	file.close()
	if json_result.error == OK:
		dic_json_result = json_result.result
	else:
		print("JSON read error, line %s" % [json_result.error_line])
	return dic_json_result

func load_external_png(filepath:String):
	var f = File.new()
	f.open(filepath,File.READ)
	var buffer = f.get_buffer(f.get_len())
	f.close()
	var img = Image.new()
	if img.load_png_from_buffer(buffer) != 0:
		print("Error, Load Image Failure")
		return
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	return texture

func function_cal(type:String,input=null):
	match type:
		"Pole-Negative":
			return false
		"Pole-Positive":
			return true
		"Gate-And":
			return (input[0] and input[1])











