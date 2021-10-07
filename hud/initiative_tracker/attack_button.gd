extends InitiativeButton


func _is_disabled(new_first: InitiativeEntry) -> bool:
	return ._is_disabled(new_first) or not new_first.token or new_first.token.get_attack().empty()
