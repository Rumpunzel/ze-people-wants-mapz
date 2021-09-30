extends Node2D

export var grid_size := 256.0
export var grid_color := Color("c89b0000")
export var line_thickness := 5.0


func _draw() -> void:
	var current_camera: Camera2D = get_tree().get_nodes_in_group("Camera2D").front()
	
	if current_camera.zoom.x <= 1.0:
		_draw_grid(current_camera, Vector2(grid_size, grid_size) * 0.2, Color("20000000"), line_thickness * 0.3)
	
	var smallest_grid := int(max(sqrt(current_camera.zoom.x) - 1.0, 0.0))
	for i in range(smallest_grid, smallest_grid + 1):
		var factor := pow(2.0, i)
		_draw_grid(current_camera, Vector2(grid_size, grid_size) * factor, grid_color, line_thickness * factor)


func _process(delta: float) -> void:
	update()



func _draw_grid(current_camera: Camera2D, cell_size: Vector2, line_color: Color, line_width: float) -> void:
	var size := get_viewport().size * current_camera.zoom * 0.5
	var camera_position := current_camera.position
	
	var begin_of_colomns := int((camera_position.x - size.x) / cell_size.x) - 1
	var end_of_colomns := int((size.x + camera_position.x) / cell_size.x) + 1
	for i in range(begin_of_colomns, end_of_colomns):
		draw_line(
			Vector2(i * cell_size.y, camera_position.y + size.y),
			Vector2(i * cell_size.y, camera_position.y - size.y),
			line_color,
			line_width
		)
	
	var begin_of_rows := int((camera_position.y - size.y) / cell_size.y) - 1
	var end_of_rows := int((size.y + camera_position.y) / cell_size.y) + 1
	for i in range(begin_of_rows, end_of_rows):
		draw_line(
			Vector2(camera_position.x + size.x, i * cell_size.x),
			Vector2(camera_position.x - size.x, i * cell_size.x),
			line_color,
			line_width
		)
