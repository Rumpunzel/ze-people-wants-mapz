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


const DAMAGE_COLORS := {
	PhysicalDamageTypes.BLUDGEONING : Color("ffffff"),
	PhysicalDamageTypes.PIERCING : Color("ffffff"),
	PhysicalDamageTypes.SLASHING : Color("ffffff"),
	
	MagicalDamageTypes.ACID : Color("00ff00"),
	MagicalDamageTypes.COLD : Color("00ffff"),
	MagicalDamageTypes.FIRE : Color("ff8000"),
	MagicalDamageTypes.FORCE : Color("80ffffff"),
	MagicalDamageTypes.LIGHTNING : Color("0000ff"),
	MagicalDamageTypes.NECROTIC : Color("000000"),
	MagicalDamageTypes.POISON : Color("008000"),
	MagicalDamageTypes.PSYCHIC : Color("ff00ff"),
	MagicalDamageTypes.RADIANT : Color("ffff00"),
	MagicalDamageTypes.THUNDER : Color("8000ff"),
}


# warning-ignore-all:unused_class_variable
export var roll_to_hit := true
export var to_hit_bonus := 0

export var dice_amount := 1
export(Die.DiceTypes) var die_type := Die.DiceTypes.d6
export var damage_bonus := 0



func get_damage_type() -> int:
	assert(false)
	return -1
