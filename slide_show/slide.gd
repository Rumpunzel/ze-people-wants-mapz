class_name Slide
extends Control

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _tween: Tween = $Tween


func display() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if visible:
		return
	
	_animation_player.play("fade_in")


func undisplay() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if not visible:
		return
	
	_animation_player.play("fade_out")
