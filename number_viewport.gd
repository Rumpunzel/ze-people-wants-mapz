extends Node


var created_textures := { }


func _ready() -> void:
	for child in get_children():
		child.get_node("Label").text = child.name
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	for child in get_children():
		var image: Image = child.get_texture().get_data()
		var new_texture := ImageTexture.new()
		
		new_texture.create_from_image(image)
		created_textures[child.name] = new_texture


func get_die_side(text: String) -> ImageTexture:
	return created_textures.get(text, null)
