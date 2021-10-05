class_name ToTake
extends OptionButton

enum {
	HALF_DAMAGE,
	NO_DAMAGE,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_item("Half Damage", HALF_DAMAGE)
	add_item("No Damage", NO_DAMAGE)

