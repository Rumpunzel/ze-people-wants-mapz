class_name MagicalAttack
extends Attack

export(MagicalDamageTypes) var damage_type


func get_damage_type() -> int:
	return damage_type
