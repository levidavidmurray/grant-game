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
	if ConfigLoader.Instance.debug_no_enemy_move:
		return
		
	position += (player.position - position) / 50

	var collision = move_and_collide(motion)
	if collision:
		print(collision)
	if collision and collision.collider:
		var col := collision.collider as Node2D
		print(col.name)
		if col.is_in_group("Weapon"):
			print("Weapon! %s" % col.name)
	
func _process(delta) -> void:
	if is_dead and dp and !dp.emitting:
		particles_played = true
		dp.queue_free() # clean up particles
		queue_free() # delete enemy

	
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
