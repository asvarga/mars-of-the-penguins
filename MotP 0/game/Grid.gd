extends TileMap

"""
functions like request_* are the ones that will be available to bot scripts
"""

enum CellType { NONE = -1, EMPTY, WALL }

var screen_size = OS.get_window_size()
var cell_to_agent = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	position = (screen_size-cell_size*scale)/2
	
	var s = 8
	for x in range(-s,s+1):
		for y in range(-s,s+1):
			set_cellv(Vector2(x, y), CellType.WALL)
	for x in range(-s+1,s):
		for y in range(-s+1,s):
			set_cellv(Vector2(x, y), CellType.EMPTY)
	for i in range(10):
		set_cellv(Vector2(randi()%int(2*s)-s, randi()%int(2*s)-s), CellType.WALL)

	scale($Penguin)
	move($Penguin, Vector2())

	scale($Bot)
	move($Bot, Vector2(4, 0))

func scale(obj):
	var p_shape = obj.get_node("Area2D/CollisionShape2D").shape.get_extents()*2
	var p_size = cell_size / p_shape
	var p_scale = min(p_size.x, p_size.y) * 0.9
	obj.scale = Vector2(p_scale, p_scale)

func move(agent, pos): 
	cell_to_agent.erase(agent.pos)
	cell_to_agent[pos] = agent
	return agent.move(pos, map_to_world(pos)+cell_size/2)
	
func request_move(agent, dir):
	if not agent.can_look(dir): return false
	var pos = agent.pos + dir
	match look(pos):
		[CellType.EMPTY, null]: return move(agent, pos)
	return false

func look(pos): 
	return [get_cellv(pos), cell_to_agent[pos] if pos in cell_to_agent else null]

func request_look (agent, dir): 
	if not agent.can_look(dir): return [null, null]
	return look(agent.pos + dir)

func tick():
	for child in get_children(): child.tick()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
