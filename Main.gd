extends Node2D

@onready var map = $TileMap
@onready var cam = $Camera2D
@onready var bomb = preload("res://Bomb.tscn")
@onready var bomba = preload("res://Bomba.tscn")
@onready var explosion = preload("res://Explosion.tscn")
var BOMBAS: Array[Bomba] = []

const H = 11
const W = 21
# Called when the node enters the scene tree for the first time.
func _ready():
	var cell = 0

	# outside walls
	for y in range(-1, H + 1):
		map.set_cell(1, Vector2i(-1, y), 0, Vector2i(2, 0))
		map.set_cell(1, Vector2i(W, y), 0, Vector2i(2, 0))
	for x in range(-1, W + 1):
		map.set_cell(1, Vector2i(x, -1), 0, Vector2i(2, 0))
		map.set_cell(1, Vector2i(x, H), 0, Vector2i(2, 0))
	
	for y in range(H):
		for x in range(W):
			map.set_cell(0, Vector2i(x, y), 0, Vector2i(cell, 0))
			cell = 1 if cell == 0 else 0
			
			if x % 2 == 1 and y % 2 == 1:
				map.set_cell(1, Vector2i(x, y), 0, Vector2i(2, 0))
			
	cam.position.x = (W / 2.0) * 16
	cam.position.y = (H / 2.0) * 16 + 6

	_new_bomba(1, 40, 40)
	_new_bomba(2, 296, 136)

#func _input(event: InputEvent):
	#if event is InputEventKey:

	#event.keycode == KEY_1326.2
func _new_bomba(player: int, x: int, y: int):
	var b = bomba.instantiate()
	b.player = player
	b.position.x = x
	b.position.y = y
	b.place_bomb.connect(_handle_place_bomb)
	BOMBAS.push_back(b)
	add_child(b)

func _handle_place_bomb(player: int):
	var b = bomb.instantiate()
	var bb = BOMBAS[player - 1]
	var x = round(bb.position.x / 16) * 16 - 8
	var y = round(bb.position.y / 16) * 16 - 2
	match bb.facing:
		bb.Facing.Up:
			y += 16
		bb.Facing.Down:
			y -= 16
		bb.Facing.Left:
			x -= 16
		bb.Facing.Right:
			x += 16
	b.position = Vector2i(x, y)
	var timer: Timer = b.find_child('Timer')
	timer.connect('timeout', _handle_bomb_explode.bind(b))
	add_child(b)

func _make_explosion(cx: int, cy: int):
	var particle = explosion.instantiate()
	particle.position.x = cx * 16 + 8
	particle.position.y = cy * 16 + 14
	particle.emitting = true
	get_tree().current_scene.add_child(particle)

func _handle_bomb_explode(b: Bomb):
	var cell = map.local_to_map(b.position)
	_make_explosion(cell.x, cell.y)

	var curr = Vector2i()
	for x in range(1, 3):
		curr = cell + Vector2i.RIGHT * x
		if map.get_cell_source_id(1, curr) != -1:
			break
		_make_explosion(curr.x, curr.y)

	for x in range(1, 3):
		curr = cell + Vector2i.LEFT * x
		if map.get_cell_source_id(1, curr) != -1:
			break
		_make_explosion(curr.x, curr.y)

	for x in range(1, 3):
		curr = cell + Vector2i.UP * x
		if map.get_cell_source_id(1, curr) != -1:
			break
		_make_explosion(curr.x, curr.y)

	for x in range(1, 3):
		curr = cell + Vector2i.DOWN * x
		if map.get_cell_source_id(1, curr) != -1:
			break
		_make_explosion(curr.x, curr.y)

	b.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
