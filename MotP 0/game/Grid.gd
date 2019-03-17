extends TileMap

enum CellType { NONE = -1, EMPTY, WALL}

var screen_size = OS.get_window_size()

# Called when the node enters the scene tree for the first time.
func _ready():
	var p_shape = $Penguin/Area2D/CollisionShape2D.shape.get_extents()*2
	var p_size = cell_size / p_shape
	var p_scale = min(p_size.x, p_size.y) * 0.9
	$Penguin.scale = Vector2(p_scale, p_scale)
	move($Penguin, Vector2())
	
	position = (screen_size-cell_size)/2
	
	var s = 4
	for x in range(-s,s+1):
		for y in range(-s,s+1):
			set_cellv(Vector2(x, y), CellType.WALL)
	for x in range(-s+1,s):
		for y in range(-s+1,s):
			set_cellv(Vector2(x, y), CellType.EMPTY)

func move(obj, pos): obj.position = map_to_world(pos) + cell_size/2
	
func request_move(obj, dir):
	var pos = world_to_map(obj.position) + dir#.normalized()
	match get_cellv(pos):
		CellType.EMPTY: move(obj, pos)
		#CellType.WALL:  break 
	return world_to_map(obj.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


