class_name InitiativeEntry
extends PanelContainer

var initiave: Attributes.Initiative
var token: Token


func _exit_tree() -> void:
	if token:
		token.disconnect("hit_points_changed", self, "_on_hit_points_changed")


func setup(new_initiaive: Attributes.Initiative, new_token: Token) -> void:
	initiave = new_initiaive
	token = new_token
	
	var initiative_label: Label = $MarginContainer/HBoxContainer/Initiative
	initiative_label.text = "%d" % initiave.initiative
	
	if token:
		# warning-ignore:return_value_discarded
		token.connect("hit_points_changed", self, "_on_hit_points_changed")
		
		var image: TextureRect = $MarginContainer/HBoxContainer/Image
		image.texture = token.image.texture
		
		var name_label: Label = $MarginContainer/HBoxContainer/Name
		name_label.text = token.name
		var font: DynamicFont = name_label.get_font("font").duplicate()
		font.outline_color = token.color
		name_label.set("custom_fonts/font", font)


func _on_hit_points_changed(new_hit_points: int) -> void:
	if new_hit_points <= 0:
		modulate = Color.darkgray
	else:
		modulate = Color.white
