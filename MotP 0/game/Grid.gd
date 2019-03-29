extends TileMap

var Bot = preload("res://agents/bot/Bot.tscn")
onready var util = preload("res://util.gd").new()
onready var Modes = util.Modes

"""
functions like request_* are the ones that will be available to bot scripts
"""

onready var Game = get_parent().get_parent()

enum CellType { NONE = -1, EMPTY, WALL }
enum Action { MOVE, SEND }

# var screen_size = OS.get_window_size()
var cell_to_agent = {}
var QUEUE = []
var dirs = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

var bots = []

export(int) var num_bots = 10
export(int) var wall_rarity = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	# position = (screen_size-cell_size*scale)/2
	position = (-cell_size*scale)/2
	
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
		add_child(bot)
		move(bot, Vector2(randi()%int(2*w1)-w1, randi()%int(2*h1)-h1), false)
		bot.dir = dirs[randi()%4]
		bots.append(bot)

	# var bot 
	# bot = Bot.instance()
	# add_child(bot)
	# move(bot, Vector2(4, 2), false)
	# bot.dir = Vector2(1, 0)
	# bot.set_mode(Modes.LEFT)
	# bots.append(bot)
	# bot = Bot.instance()
	# add_child(bot)
	# move(bot, Vector2(9, 6), false)
	# bot.dir = Vector2(0, -1)
	# bot.set_mode(Modes.CENTER)
	# bots.append(bot)
	# bot = Bot.instance()
	# add_child(bot)
	# move(bot, Vector2(14, 2), false)
	# bot.dir = Vector2(-1, 0)
	# bot.set_mode(Modes.RIGHT)
	# bots.append(bot)

	move($Penguin, Vector2(0, 0), false)

func scale(obj):
	var p_shape = obj.get_node("Area2D/CollisionShape2D").shape.get_extents()*2
	var p_size = cell_size / p_shape
	var p_scale = min(p_size.x, p_size.y) * 0.8
	obj.scale = Vector2(p_scale, p_scale)

func move(agent, pos, animate=true): 
	cell_to_agent.erase(agent.pos)
	cell_to_agent[pos] = agent
	return agent.move(pos, map_to_world(pos)+cell_size/2, animate)
	
func request_move(agent, dir, now=false):
	if not agent.can_move(dir): return
	var pos = agent.pos + dir
	match look(pos):
		[CellType.EMPTY, null]: 
			if now: move(agent, pos)
			else: queue([Action.MOVE, agent, pos])

func look(pos): 
	return [get_cellv(pos), cell_to_agent[pos] if pos in cell_to_agent else null]

func request_look(agent, dir): 
	if not agent.can_look(dir): return null #[null, null]
	return look(agent.pos + dir)

func send(rec, msg): 
	# if not rec.paused: rec.receive(msg)
	rec.receive(msg)

func request_send(agent, dir, msg, now=false):
	if not agent.can_send(dir): return
	match look(agent.pos + dir):
		[_, var rec]: 
			if rec == null: continue
			if now: send(rec, msg)
			else: queue([Action.SEND, rec, msg])
			return rec

# every action step
func tick():
	go() 						# might be events queued from penguin
	for bot in bots: 			# process
		if not bot.paused: bot.tick()	
	go() 						# execute in parallel

# queue up actions
func queue(action): QUEUE.append(action)

# do queued actions
func go():
	# first pass: look for conflicts
	var pos_to_bots = {}
	var bot_to_msgs = {}
	for action in QUEUE:
		match action:
			[Action.MOVE, var bot, var pos]: 
				if not pos in pos_to_bots: 	pos_to_bots[pos] = {bot: true}
				else: 						pos_to_bots[pos][bot] = true
			[Action.SEND, var bot, var msg]: 
				if not bot in bot_to_msgs: 	bot_to_msgs[bot] = {msg: true}
				else: 						bot_to_msgs[bot][msg] = true
	QUEUE = []

	# second pass: execute
	for pos in pos_to_bots:
		var bots = pos_to_bots[pos]
		if len(bots) == 1: move(util.pop(bots), pos)
		else: for bot in bots: bot.failed(pos)
	for bot in bot_to_msgs:
		var msgs = bot_to_msgs[bot]
		if len(msgs) == 1: send(bot, util.pop(msgs))


func request_edit(agent, dir):
	if not agent.can_edit(dir): return
	match look(agent.pos + dir):
		[_, var bot]: if bot: Game.edit(agent, bot)