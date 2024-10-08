#credit: https://github.com/MyNameIsntBob/2D_Platformer_Pathfinding_Demo/blob/master/Pathfinder.gd
extends Node2D

var cell_size = 16

var jumpHeight = 2
var jumpDistance = 2

var tileMap
var graph 

var showLines = true



func findPath(start, end):
	var first_point = graph.get_closest_point(start)
	var finish = graph.get_closest_point(end)
	var path = graph.get_id_path(first_point, finish)
	
	if (len(path) == 0):
		return path
	
	var actions = []
	
	var lastPos
	
	for point in path:
		var pos = graph.get_point_position(point)
		var stat = cellType(pos, true, true)
		
		if lastPos and lastPos[1] >= pos[1] - (cell_size * jumpHeight) and ((lastPos[0] < pos[0] and stat[0] < 0) or (lastPos[0] > pos[0] and stat[1] < 0)):
			actions.append(null)

		lastPos = pos
		
		if point == path[0] and len(path) > 1:
			var nextPos = graph.get_point_position(path[1])
			if start.distance_to(nextPos) > pos.distance_to(nextPos): 
				actions.append(pos)
		elif point == path[-1] and len(path) > 1:
			if (graph.get_point_position(path[-2]).distance_to(end) < pos.distance_to(end)):
				actions.append(pos)
		else:
			actions.append(pos)
	actions.append(end)
	return actions

func _ready():
	graph = AStar2D.new()
	tileMap = find_parent("Main").get_node("TileMap")
	createMap()
	createConections()

func createConections():
	var points = graph.get_points()
	for point in points:
		var closestRight = -1
		var closestLeftDrop = -1
		var closestRightDrop = -1
		var pos = graph.get_point_position(point)	
		var stat = cellType(pos, true, true)

		var pointsToJoin = []
		var noBiJoin = []

		for newPoint in points:
			var newPos = graph.get_point_position(newPoint)
			if (stat[1] == 0): 
				if (newPos[1] == pos[1] and newPos[0] > pos[0]):
					if closestRight < 0 or newPos[0] < graph.get_point_position(closestRight)[0]: 
						closestRight = newPoint
			if (stat[0] == -1):
				if (newPos[0] == pos[0] - cell_size and newPos[1] > pos[1]):
					if closestLeftDrop < 0 or newPos[1] < graph.get_point_position(closestLeftDrop)[1]:
						closestLeftDrop = newPoint
				if (newPos[1] >= pos[1] - (cell_size * jumpHeight) and newPos[1] <= pos[1] and 
					newPos[0] > pos[0] - (cell_size * (jumpDistance + 2)) and newPos[0] < pos[0]) and cellType(newPos, true, true)[1] == -1 :
						pointsToJoin.append(newPoint)
			if (stat[1] == -1):
				if (newPos[0] == pos[0] + cell_size and newPos[1] > pos[1]):
					if closestRightDrop < 0 or newPos[1] < graph.get_point_position(closestRightDrop)[1]:
						closestRightDrop = newPoint
				if (newPos[1] >= pos[1] - (cell_size * jumpHeight) and newPos[1] <= pos[1] and 
					newPos[0] < pos[0] + (cell_size * (jumpDistance + 2)) and newPos[0] > pos[0]) and cellType(newPos, true, true)[0] == -1 :
						pointsToJoin.append(newPoint)

		if (closestRight > 0):
			pointsToJoin.append(closestRight)
		if (closestLeftDrop > 0):
			if (graph.get_point_position(closestLeftDrop)[1] <= pos[1] + (cell_size * jumpHeight)):
				pointsToJoin.append(closestLeftDrop)
			else:
				noBiJoin.append(closestLeftDrop)
		if (closestRightDrop > 0):
			if (graph.get_point_position(closestRightDrop)[1] <= pos[1] + (cell_size * jumpHeight)):
				pointsToJoin.append(closestRightDrop)
			else:
				noBiJoin.append(closestRightDrop)

		for joinPoint in pointsToJoin:
			graph.connect_points (point, joinPoint)
		for joinPoint in noBiJoin:
			graph.connect_points (point, joinPoint, false)

func _draw():
	if !showLines:
		return
	
	var points = graph.get_points()
	for point in points:
		var closestRight = -1
		var closestLeftDrop = -1
		var closestRightDrop = -1
		var pos = graph.get_point_position(point)	
		var stat = cellType(pos, true, true)

		var pointsToJoin = []
		var noBiJoin = []

		for newPoint in points:
			var newPos = graph.get_point_position(newPoint)
			if (stat[1] == 0 and newPos[1] == pos[1] and newPos[0] > pos[0]):
				if closestRight < 0 or newPos[0] < graph.get_point_position(closestRight)[0]: 
					closestRight = newPoint
			if (stat[0] == -1):
				if (newPos[0] == pos[0] - cell_size and newPos[1] > pos[1]):
					if closestLeftDrop < 0 or newPos[1] < graph.get_point_position(closestLeftDrop)[1]:
						closestLeftDrop = newPoint
				if (newPos[1] >= pos[1] - (cell_size * jumpHeight) and newPos[1] <= pos[1] and 
					newPos[0] > pos[0] - (cell_size * (jumpDistance + 2)) and newPos[0] < pos[0]) and cellType(newPos, true, true)[1] == -1 :
						pointsToJoin.append(newPoint)
			if (stat[1] == -1):
				if (newPos[0] == pos[0] + cell_size and newPos[1] > pos[1]):
					if closestRightDrop < 0 or newPos[1] < graph.get_point_position(closestRightDrop)[1]:
						closestRightDrop = newPoint
				if (newPos[1] >= pos[1] - (cell_size * jumpHeight) and newPos[1] <= pos[1] and 
					newPos[0] < pos[0] + (cell_size * (jumpDistance + 2)) and newPos[0] > pos[0]) and cellType(newPos, true, true)[0] == -1 :
						pointsToJoin.append(newPoint)

		if (closestRight > 0):
			pointsToJoin.append(closestRight)
		if (closestLeftDrop > 0):
			if (graph.get_point_position(closestLeftDrop)[1] <= pos[1] + (cell_size * jumpHeight)):
				pointsToJoin.append(closestLeftDrop)
			else:
				noBiJoin.append(closestLeftDrop)
		if (closestRightDrop > 0):
			if (graph.get_point_position(closestRightDrop)[1] <= pos[1] + (cell_size * jumpHeight)):
				pointsToJoin.append(closestRightDrop)
			else:
				noBiJoin.append(closestRightDrop)

		for joinPoint in pointsToJoin:
			draw_line(pos, graph.get_point_position(joinPoint), Color(255, 0, 0), 1)
		for joinPoint in noBiJoin:
			draw_line(pos, graph.get_point_position(joinPoint), Color(0, 255, 0), 1)
			
func createMap():
	var space_state = get_world_2d().direct_space_state
	var cells = tileMap.get_used_cells()
	
	for cell in cells:
		var stat = cellType(cell)

		if (stat and stat != Vector2(0, 0)):
			createPoint(cell)
			
			if stat[1] == -1:
				var pos = tileMap.map_to_world(Vector2(cell[0] + 1, cell[1]))
				var pto = Vector2(pos[0], pos[1] + 1000)
				
				var result = get_parent().ray_query(pos, pto)
				if (result):					
					createPoint(tileMap.world_to_map(result.position))

			if stat[0] == -1:
				var pos = tileMap.map_to_world(Vector2(cell[0] - 1, cell[1]))
				var pto = Vector2(pos[0], pos[1] + 1000)
				var result = get_parent().ray_query(pos, pto)
				if (result):
					createPoint(tileMap.world_to_map(result.position))

func cellType(pos, global = false, isAbove = false):
	if (global):
		pos = tileMap.world_to_map(pos)
	if isAbove:
		pos += Vector2.DOWN
	var cells = tileMap.get_used_cells()
	
	
	if (pos + Vector2.UP in cells):
#		If there's a block above the passes one, return null
		return null
	var results = Vector2(0, 0)
	
#	Checking left
	if pos + Vector2.UP + Vector2.LEFT in cells:
#		if wall
		results[0] = 1
	elif !(pos + Vector2.LEFT in cells):
#		if drop
		results[0] = -1
		
#	Checking right
	if pos + Vector2.UP + Vector2.RIGHT in cells:
#		if wall
		results[1] = 1
	elif !(pos + Vector2.RIGHT in cells):
#		if drop
		results[1] = -1
	return results

func createPoint(cell):
	var above = Vector2(cell[0], cell[1] - 1)
	var pos = tileMap.map_to_world(above) + Vector2(cell_size/2, cell_size/2)
	if graph.get_points() and graph.get_point_position(graph.get_closest_point(pos)) == pos:
		return
	
	graph.add_point(graph.get_available_point_id(), pos)
