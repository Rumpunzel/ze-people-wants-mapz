extends SpotLight



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var world := get_world()
	if not world:
		return
	
	var environment := world.environment
	if not environment:
		return
	
	var sky: ProceduralSky = environment.background_sky
	if not sky:
		return
	
	light_color = sky.sun_color
