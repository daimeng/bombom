class_name Bomb
extends RigidBody2D

#func _physics_process(_delta):
	#position.x = round(position.x / 16) * 16 - 8
	#position.y = round(position.y / 16) * 16 - 2
