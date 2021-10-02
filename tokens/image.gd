tool
extends TextureRect


export(String, DIR) var _portraits_directory: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not _portraits_directory.empty():
		var image_paths := FileHelper.list_files_in_directory(_portraits_directory, true, ".png")
		texture = load(image_paths[randi() % image_paths.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
