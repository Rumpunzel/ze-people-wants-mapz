tool
extends TextureRect


export(Array, Texture) var _additional_images := [ ]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not _additional_images.empty():
		var images := [texture] + _additional_images
		texture = images[randi() % images.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
