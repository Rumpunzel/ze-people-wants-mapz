class_name Slide
extends Control

# warning-ignore-all:unused_signal
signal faded_in
signal faded_out

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _tween: Tween = $Tween


func display() -> void:
	if visible:
		return
	
	_animation_player.play("fade_in")


func undisplay() -> void:
	if not visible:
		return
	
	_animation_player.play("fade_out")
