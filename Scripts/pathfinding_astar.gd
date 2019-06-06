extends TileMap

onready var astar_node = AStar.new()
export(Vector2) var map_size = Vector2(64, 50)

#var path_start_position = Vector2() setget set_path_start_position
#var path_end_position = Vector2() setget set_path_end_position

var obstacles = get_used_cells_by_id(2)
var _point_path = []
var _half_cell_size = self.cell_size/2

func _ready():
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells_diagonal(walkable_cells_list)

func astar_add_walkable_cells(obstacles = []):
	var points_array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point = Vector2(x, y)
			if point in obstacles:
				continue

			points_array.append(point)
			# The AStar class references points with indices
			# Using a function to calculate the index from a point's coordinates
			# ensures we always get the same index with the same input point
			var point_index = calculate_point_index(point)
			# AStar works for both 2d and 3d, so we have to convert the point
			# coordinates from and to Vector3s
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array

func astar_connect_walkable_cells_diagonal(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)

				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar_node.has_point(point_relative_index):
					continue
				astar_node.connect_points(point_index, point_relative_index, true)

func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y

func calculate_point_index(point):
	return point.x + map_size.x * point.y

func get_path(world_start, world_end):
	if is_outside_map_bounds(world_to_map(world_start)) or is_outside_map_bounds(world_to_map(world_end)):
		return []
	var path_start_position = world_to_map(world_start)
	var path_end_position = world_to_map(world_end)
	_recalculate_path(path_start_position, path_end_position)
	var path_world = []
	for point in _point_path:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	print(path_world)
	return path_world

func _recalculate_path(path_start_position, path_end_position):
	#clear_previous_path_drawing()
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	# This method gives us an array of points. Note you need the start and end
	# points' indices as input
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	# Redraw the lines and circles from the start to the end point
	update()
"""
func set_path_start_position(val):
	path_start_position = val
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()

func set_path_end_position(val):
	path_end_position = val
	if path_start_position != val:
		_recalculate_path()
"""