extends KinematicBody2D

signal bullet_shot
signal death

var bullet = preload("res://Prefabs/Bullet.tscn")

var movespeed = 500
var bullet_speed = 1500
var is_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
		var motion = Vector2()
		
		if Input.is_action_just_pressed("restart"):
			print("")
			print("==== RELOAD ====")
			print(" --- ROOT --- ")
			for _i in get_tree().get_root().get_children():
				print(_i)
			print(" --- WORLD --- ")
			for _i in get_node("/root/World").get_children():
				print(_i)
			get_tree().reload_current_scene()
			return
			
		if is_dead:
			return
		
		if Input.is_action_pressed("up"):
			motion.y -= 1
		if Input.is_action_pressed("down"):
			motion.y += 1	
		if Input.is_action_pressed("right"):
			motion.x += 1		
		if Input.is_action_pressed("left"):
			motion.x -= 1		
		motion = motion.normalized()
		motion = move_and_slide(motion * movespeed)
		
		# look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("LMB"):
			fire()
			
		if Input.is_action_pressed("exit"):
			get_tree().quit()
			
			
func set_colliders_enabled(enabled: bool) -> void:
	var area = get_node("Area2D")
	area.get_node("CollisionShape2D").call_deferred('set', 'disabled', !enabled)
	area.get_node("CollisionShape2D2").call_deferred('set', 'disabled', !enabled)
			
func fire():
	emit_signal('bullet_shot')
	$BulletSound.play()
	var bullet_instance: RigidBody2D = bullet.instance()

	var mouse_pos: Vector2 = get_global_mouse_position()
	bullet_instance.position = get_global_position()

	var bullet_dir: Vector2 = (mouse_pos - bullet_instance.position).normalized()
	# bullet_instance.rotation_degrees = rotation_degrees

	bullet_instance.apply_impulse(Vector2(), bullet_dir * bullet_speed)
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	

func die():
	emit_signal('death')
	is_dead = true
	set_colliders_enabled(false)
	$AnimationPlayer.play("DeathFlash")
	$DeathSound.play()
	yield($DeathSound, "finished")
	yield($AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		die()

