class_name InitiativeButton
extends Button

export var _needs_token := true

func _on_initiative_changed(new_first: InitiativeEntry) -> void:
	disabled =_is_disabled(new_first)

func _is_disabled(new_first: InitiativeEntry) -> bool:
	return not new_first or (_needs_token and not new_first.token)
