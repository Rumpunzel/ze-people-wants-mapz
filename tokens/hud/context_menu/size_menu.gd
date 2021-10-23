extends PopupMenu

var _currently_checked_index: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for value in Attributes.Size.keys():
		var size: String = value
		var flag_value: int = Attributes.Size[size]
		
		add_radio_check_item(size.capitalize(), flag_value)
	
	yield(get_tree(), "idle_frame")
	
	var token: Token = owner
	_currently_checked_index = get_item_index(token.size)
	set_item_checked(_currently_checked_index, true)


func _on_visibility_changed() -> void:
	if visible:
		modulate.a = 0.0
		yield(get_tree(), "idle_frame")
		
		var parent: PopupMenu = get_parent()
		rect_global_position = Vector2(
			parent.rect_global_position.x + parent.rect_size.x,
			parent.rect_global_position.y
		)
		modulate.a = 1.0


func _on_id_pressed(id: int) -> void:
	set_item_checked(_currently_checked_index, false)
	_currently_checked_index = get_item_index(id)
	set_item_checked(_currently_checked_index, true)
