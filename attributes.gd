class_name Attributes
extends Resource


export var level := 1
export var hit_die := 8
export var roll_hit_points := true

export var armor_class := 15

export var strength := 10
export var dexterity := 10
export var constitution := 10
export var intelligence := 10
export var wisdom := 10
export var charisma := 10


static func calculate_modifier(attribute: int) -> int:
	return int(attribute * 0.5) - 5


func calculate_hit_points() -> int:
	return Die.roll(level, hit_die, not roll_hit_points) + level * calculate_modifier(constitution)
