extends OptionButton


export(String, DIR) var _stat_icons_directory: String

var _stat_icons := { }

onready var _stat_icon_paths := FileHelper.list_files_in_directory(_stat_icons_directory, false, ".png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_item("None")
	
	for path in _stat_icon_paths:
		var icon_path: String = path
		_stat_icons[icon_path.get_file().get_basename()] = load(icon_path)
	
	for type in Attributes.Stats.keys():
		var stat: String = type
		var flag_value: int = Attributes.Stats[stat]
		
		add_icon_item(_stat_icons[stat.to_lower()], stat.capitalize(), flag_value)
