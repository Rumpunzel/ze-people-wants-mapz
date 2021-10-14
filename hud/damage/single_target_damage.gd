extends PopupPanel


var _being_dragged := false
var _offset := Vector2.ZERO
var _token: Token = null


onready var _damage: LineEdit = $MarginContainer/VBoxContainer/VBoxContainer/Damage
onready var _magical: CheckButton = $MarginContainer/VBoxContainer/VBoxContainer/Magical
onready var _damage_type: OptionButton = $MarginContainer/VBoxContainer/VBoxContainer/DamageType
onready var _dc: LineEdit = $MarginContainer/VBoxContainer/VBoxContainer/DC
onready var _saving_throw: OptionButton = $MarginContainer/VBoxContainer/VBoxContainer/SavingThrow
onready var _to_take: ToTake = $MarginContainer/VBoxContainer/VBoxContainer/ToTake



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# warning-ignore:return_value_discarded
	ShittySingleton.connect("single_target_dialog_openend", self, "_on_single_target_dialog_openend")


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			_being_dragged = mouse_event.pressed
			
			if mouse_event.pressed:
				_offset = get_global_mouse_position() - rect_position
			
			get_tree().set_input_as_handled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if _being_dragged:
		rect_position = get_global_mouse_position() - _offset



func _on_single_target_dialog_openend(token: Token) -> void:
	_token = token
	
	set_as_minsize()
	popup()
	
	_damage.grab_click_focus()
	_damage.grab_focus()


func _on_done_pressed(_text_entered: String = "") -> void:
	var amount := int(_damage.text)
	var magical := _magical.pressed
	var damage_type := _damage_type.get_selected_id()
	var damage_type_string := _damage_type.get_item_text(_damage_type.get_item_index(damage_type))
	var dc := int(_dc.text)
	var saving_throw_to_make := _saving_throw.get_selected_id()
	var to_take := _to_take.get_selected_id()
	
	_token.damage(amount, magical, damage_type, damage_type_string, dc, saving_throw_to_make, to_take)
