class_name PhysicalAttack
extends Attack

export(PhysicalDamageTypes) var damage_type


func get_damage_type() -> int:
	return damage_type
