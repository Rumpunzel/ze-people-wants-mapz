class_name PlayerInitiatives
extends PopupPanel

signal initiatives_confirmed(player_initiatives)

onready var _grid: GridContainer = $MarginContainer/GridContaier


func display() -> void:
	if visible:
		hide()
		return
	
	var players := get_tree().get_nodes_in_group(Players.PLAYER_GROUP)
	players.sort_custom(self, "_sort_players")
	
	for index in players.size():
		var token: Token = players[index]
		var dialog: InitiativeDialog = _grid.get_child(index)
		
		dialog.token = token
		
		set_as_minsize()
		popup_centered()


func _sort_players(first_player: Token, second_player: Token) -> bool:
	return first_player.name <= second_player.name


func _on_confirm() -> void:
	var confirm_dict := { }
	var players := get_tree().get_nodes_in_group(Players.PLAYER_GROUP)
	
	for index in players.size():
		var dialog: InitiativeDialog = _grid.get_child(index)
		confirm_dict[dialog.token] = dialog.get_initiative()
		emit_signal("initiatives_confirmed", confirm_dict)
	
	hide()
