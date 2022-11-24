extends KinematicBody2D

signal bullet_shot

var movespeed = 500
var bullet_speed = 2000
var bullet = preload("res://Prefabs/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
		var motion = Vector2()
		
		if Input.is_action_just_pressed("restart"):
			print("")
			print("==== RELOAD ====")
			for _i in get_tree().get_root().get_children():
				print(_i)
			get_tree().reload_current_scene()
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
		
		look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("LMB"):
			fire()
			
		if Input.is_action_pressed("exit"):
			get_tree().quit()
			
			
func fire():
	emit_signal('bullet_shot')
	$BulletSound.play()
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	

func kill():
	$DeathSound.play()
	yield($DeathSound, "finished")
	get_tree().reload_current_scene()
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		print("levi")
		kill()

