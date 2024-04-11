class_name Bomba
extends CharacterBody2D

var player: int = 0
enum Facing {Up, Right, Down, Left}
var facing: Facing = Facing.Right
signal place_bomb(player: int)
const SPEED = 100.0
var dead = false

@onready var sprite: Sprite2D = $Sprite2D

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed("p%d_bomb" % player):
			place_bomb.emit(player)


func _physics_process(_delta):
	if dead:
		return

	var xdir = Input.get_axis("p%d_left" % player, "p%d_right" % player)
	if xdir:
		velocity.x = xdir * SPEED
		facing = Facing.Right if xdir > 0 else Facing.Left
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	var ydir = Input.get_axis("p%d_up" % player, "p%d_down" % player)
	if ydir:
		velocity.y = ydir * SPEED
		facing = Facing.Up if ydir > 0 else Facing.Down
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	match facing:
		Facing.Left:
			sprite.scale.x = -abs(sprite.scale.x)
		Facing.Right:
			sprite.scale.x = abs(sprite.scale.x)

	velocity = velocity.normalized() * SPEED
	move_and_slide()
	#move_and_collide(velocity, false)


func die():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	var tween = create_tween().set_parallel(true)
	var rndv = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 100
	tween.tween_property($Sprite2D, "rotation", 720, 2)
	tween.tween_property($Sprite2D, "position", rndv, 2).as_relative()
	tween.tween_property($Sprite2D, "self_modulate:a", 0.5, 2)
	tween.chain().tween_callback(queue_free)
