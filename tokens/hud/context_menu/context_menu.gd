class_name ContextMenu
extends PopupMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if not child is PopupMenu:
			continue
		
		var menu: PopupMenu = child
		var menu_name := menu.name
		add_submenu_item(menu_name.trim_suffix("Menu"), menu_name)


func popup_menu() -> void:
	set_as_minsize()
	popup()
	
	rect_global_position = get_global_mouse_position()
