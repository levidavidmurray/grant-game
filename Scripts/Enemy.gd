extends KinematicBody2D

var death_particles = preload("res://Prefabs/DeathParticles.tscn")

var motion = Vector2()
var is_dead: bool = false
var particles_played: bool = false
var dp: Particles2D

onready var player = get_parent().get_node("Player")
	
func _physics_process(delta):
	if is_dead:
		return
		
	position += (player.position - position)/50
#	look_at(player.position)
	move_and_collide(motion)
	
func _process(delta) -> void:
	if is_dead and dp and !dp.emitting:
		particles_played = true
		print('Cleaning up', self.name)
		# clean up particles
		dp.queue_free()
		# delete enemy
		queue_free()

	
func die() -> void:
	is_dead = true
	
	$DeathSound.play()
	
	# disable colliders to prevent further triggers & collisions
	get_node("CollisionShape2D").call_deferred('set', 'disabled', true)
	get_node("Area2D").get_node("CollisionShape2D").call_deferred('set', 'disabled', true)
	
	$AnimationPlayer.play("DeathFlash")
	
	yield($AnimationPlayer, "animation_finished")
	$Sprite.visible = false
	create_particles()
	
	
func create_particles() -> void:
	dp = death_particles.instance()
	dp.emitting = true
	dp.position = get_global_position()
	get_tree().get_root().call_deferred("add_child", dp)
	
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Bullet"):
		body.queue_free() # delete bullet
		die()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword"):
		die()
