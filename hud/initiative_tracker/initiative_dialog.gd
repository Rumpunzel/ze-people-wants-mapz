class_name InitiativeDialog
extends PanelContainer


var token: Token setget set_token

onready var _image: TextureRect = $MarginContainer/HBoxContainer/Image
onready var _name_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Name
onready var _line_edit: LineEdit = $MarginContainer/HBoxContainer/VBoxContainer/LineEdit


func set_token(new_token: Token) -> void:
	token = new_token
	_image.texture = token.image.texture
	_name_label.text = token.name

func get_initiative() -> Attributes.Initiative:
	return Attributes.Initiative.new(int(_line_edit.text), 0)
