extends GPUParticles2D

@onready var timeCreated = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Time.get_ticks_msec() - timeCreated > 500:
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Bomba:
		body.die()
