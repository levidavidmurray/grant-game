extends KinematicBody2D

var motion = Vector2()
var is_dead: bool = false

onready var player = get_parent().get_node("Player")
	
func _physics_process(delta):
	if is_dead:
		return
		
	position += (player.position - position)/50
	look_at(player.position)
	
	move_and_collide(motion)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Bullet"):
		is_dead = true
		$Sprite.visible = false
		$DeathSound.play()
		body.queue_free() # delete bullet
		
		var self_ref = weakref(self)
		yield($DeathSound, "finished")
		
		# enemy may be freed before sound finishes (e.g. player death restart)
		if self_ref.get_ref():
			queue_free() # an hero
