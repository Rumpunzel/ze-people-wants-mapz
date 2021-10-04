extends OptionButton


export(String, DIR) var _damage_icons_directory: String

var _damage_icons := { }

onready var _damage_icon_paths := FileHelper.list_files_in_directory(_damage_icons_directory, false, ".png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for path in _damage_icon_paths:
		var icon_path: String = path
		_damage_icons[icon_path.get_file().get_basename()] = load(icon_path)
	
	_add_enum(Attack.PhysicalDamageTypes)
	add_separator()
	_add_enum(Attack.MagicalDamageTypes)
	add_separator()
	_add_enum(Attack.OtherDamageTypes)


func _add_enum(damage_enum: Dictionary) -> void:
	for type in damage_enum.keys():
		var damage_type: String = type
		var flag_value: int = damage_enum[damage_type]
		
		add_icon_item(_damage_icons[damage_type.to_lower()], damage_type.capitalize(), flag_value)
