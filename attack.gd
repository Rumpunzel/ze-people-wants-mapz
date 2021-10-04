class_name Attack
extends Resource


enum PhysicalDamageTypes {
	BLUDGEONING = 1,
	PIERCING = 2,
	SLASHING = 4,
}

enum MagicalDamageTypes {
	ACID = 8,
	COLD = 16,
	FIRE = 32,
	FORCE = 64,
	LIGHTNING = 128,
	NECROTIC = 256,
	POISON = 512,
	PSYCHIC = 1024,
	RADIANT = 2048,
	THUNDER = 4096,
}

enum OtherDamageTypes {
	HEALING = 8192,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
