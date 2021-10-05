class_name Attributes
extends Resource

enum Stats {
	STRENGTH = 1,
	DEXTERITY = 2,
	CONSTITUTION = 4,
	INTELLIGENCE = 8,
	WISDOM = 16,
	CHARISMA = 32,
}

enum Size {
	TINY = 1,
	SMALL = 2,
	MEDIUM = 4,
	LARGE = 8,
	HUGE = 16,
	GARGANTUAN = 32,
}


# warning-ignore-all:unused_class_variable
export var level := 1
export var hit_die := 8
export var roll_hit_points := true

export(Size) var size := Size.MEDIUM
export var move_speed := 30

export var armor_class := 10

export var strength := 10
export var dexterity := 10
export var constitution := 10
export var intelligence := 10
export var wisdom := 10
export var charisma := 10

export var strength_saving_throw_bonus := 0
export var dexterity_saving_throw_bonus := 0
export var constitution_saving_throw_bonus := 0
export var intelligence_saving_throw_bonus := 0
export var wisdom_saving_throw_bonus := 0
export var charisma_saving_throw_bonus := 0


export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing"
) var non_magical_resistances := 0

export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing",
	"Acid",
	"Cold",
	"Fire",
	"Force",
	"Lightning",
	"Necrotic",
	"Poison",
	"Psychic",
	"Radiant",
	"Thunder"
) var magical_resistances := 0


export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing"
) var non_magical_immunities := 0

export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing",
	"Acid",
	"Cold",
	"Fire",
	"Force",
	"Lightning",
	"Necrotic",
	"Poison",
	"Psychic",
	"Radiant",
	"Thunder"
) var magical_immunities := 0


export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing"
) var non_magical_vulnerabilties := 0

export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing",
	"Acid",
	"Cold",
	"Fire",
	"Force",
	"Lightning",
	"Necrotic",
	"Poison",
	"Psychic",
	"Radiant",
	"Thunder"
) var magical_vulnerabilties := 0


export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing"
) var non_magical_damage_absorbtion := 0

export(
	int, FLAGS,
	"Bludgeoning",
	"Piercing",
	"Slashing",
	"Acid",
	"Cold",
	"Fire",
	"Force",
	"Lightning",
	"Necrotic",
	"Poison",
	"Psychic",
	"Radiant",
	"Thunder"
) var magical_damage_absorbtion := 0



func calculate_modifier(attribute: int) -> int:
	return int(attribute * 0.5) - 5

func calculate_hit_points() -> int:
	return Die.roll(level, hit_die, not roll_hit_points) + level * calculate_modifier(constitution)

func roll_initiative() -> Initiative:
	return Initiative.new(Die.roll(1, Die.DiceTypes.d20), calculate_modifier(dexterity))

func saving_throw(stat: int) -> int:
	return (Die.roll(1, Die.DiceTypes.d20) + calculate_saving_throw_modifier(stat))

func calculate_saving_throw_modifier(attribute_flag: int) -> int:
	return calculate_modifier(get("%s" % get_attribute_name(attribute_flag))) + get("%s_saving_throw_bonus" % get_attribute_name(attribute_flag))

func get_modified_damage(amount: int, damage_type: int, magical: bool) -> int:
	if magical:
		if damage_type & magical_immunities:
			return 0
		elif damage_type & magical_damage_absorbtion:
			return -amount
		elif damage_type & magical_resistances:
			return int(amount / 2.0)
		elif damage_type & magical_vulnerabilties:
			return amount * 2
	else:
		if damage_type & non_magical_immunities:
			return 0
		elif damage_type & non_magical_damage_absorbtion:
			return -amount
		elif damage_type & non_magical_resistances:
			return int(amount / 2.0)
		elif damage_type & non_magical_vulnerabilties:
			return amount * 2
	
	return amount

func get_attribute_name(attribute: int) -> String:
	return Stats.keys()[ Stats.values().find(attribute) ].to_lower()


class Initiative:
	var initiative: int
	var result: int
	var modifier: int
	
	func _init(rolled_result: int, used_modifier: int) -> void:
		result = rolled_result
		modifier = used_modifier
		initiative = result + modifier
