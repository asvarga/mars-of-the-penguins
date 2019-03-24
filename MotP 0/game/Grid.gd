extends TileMap

var Bot = preload("res://agents/bot/Bot.tscn")

"""
functions like request_* are the ones that will be available to bot scripts
"""

enum CellType { NONE = -1, EMPTY, WALL }

var screen_size = OS.get_window_size()
var cell_to_agent = {}
var QUEUE = []
var dirs = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

export(int) var num_bots = 10
export(int) var wall_rarity = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	position = (screen_size-cell_size*scale)/2
	
	var w = 15
	var h = 8
	for x in range(-w,w+1):
		for y in range(-h,h+1):
			if abs(x) == w or abs(y) == h or randi()%wall_rarity == 0: 
				set_cellv(Vector2(x, y), CellType.WALL)
			elif get_cellv(Vector2(x, y)) != CellType.WALL: 
				set_cellv(Vector2(x, y), CellType.EMPTY)
	# for i in range(10):
	# 	set_cellv(Vector2(randi()%int(2*s)-s, randi()%int(2*s)-s), CellType.WALL)
	
	var w1 = w-1
	var h1 = h-1
	for i in range(num_bots):
		var bot = Bot.instance()
		bot.modulate = Color(randf(), randf(), randf())
		add_child(bot)
		move(bot, Vector2(randi()%int(2*w1)-w1, randi()%int(2*h1)-h1), false)
		bot.dir = dirs[randi()%4]

	move($Penguin, Vector2(0, 0), false)

func scale(obj):
	var p_shape = obj.get_node("Area2D/CollisionShape2D").shape.get_extents()*2
	var p_size = cell_size / p_shape
	var p_scale = min(p_size.x, p_size.y) * 0.9
	obj.scale = Vector2(p_scale, p_scale)

func move(agent, pos, animate=true): 
	cell_to_agent.erase(agent.pos)
	cell_to_agent[pos] = agent
	return agent.move(pos, map_to_world(pos)+cell_size/2, animate)
	
func request_move(agent, dir, now=false):
	if not agent.can_look(dir): return
	var pos = agent.pos + dir
	match look(pos):
		[CellType.EMPTY, null]: 
			if now: move(agent, pos)
			else: queue([agent, pos])

func look(pos): 
	return [get_cellv(pos), cell_to_agent[pos] if pos in cell_to_agent else null]

func request_look(agent, dir): 
	if not agent.can_look(dir): return [null, null]
	return look(agent.pos + dir)

# every action step
func tick():
	for child in get_children(): child.tick()
	go()

# queue up actions
func queue(action): QUEUE.append(action)

# do queued actions
func go():
	# first pass: look for conflicts
	var counts = {}
	for action in QUEUE:
		match action:
			[var agent, var pos]: 
				counts[pos] = counts[pos]+1 if pos in counts else 1
	# second pass: execute
	for action in QUEUE:
		match action:
			[var agent, var pos]: 
				if counts[pos] == 1: move(agent, pos)
				else: agent.failed(action)
	QUEUE = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
