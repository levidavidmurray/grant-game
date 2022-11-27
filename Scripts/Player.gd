extends KinematicBody2D

signal bullet_shot
signal death

var bullet = preload("res://Prefabs/Bullet.tscn")
var movespeed = 500
var bullet_speed = 1500
var is_dead: bool = false
var sword_ready := true

onready var sword_rot: Node2D = $SwordRot
onready var sword: Sword = $SwordRot.get_node("Sword")


func _ready():
	sword.connect("sword_finish", self, "on_sword_finish")


func _process(delta):
	var global_mouse = get_global_mouse_position()

	var local_mouse_dir = to_local(global_mouse).sign().x
	self.scale *= Vector2(local_mouse_dir, 1)

	if sword_ready:
		sword_rot.look_at(global_mouse)
	else:
		# prevent active sword from being mirrored
		if local_mouse_dir < 0:
			# TODO: Fix sword being mirrored on apparent y-axis due to sword_rot rotation
			sword_rot.scale *= Vector2(local_mouse_dir, 1)



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
		
		if Input.is_action_just_pressed("RMB"):
			melee()
		
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

	bullet_instance.apply_impulse(Vector2(), bullet_dir * bullet_speed)
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	
	
func melee():
	if !sword_ready:
		return

	var sr_scale = sword_rot.scale
	sr_scale.x = self.scale.x
	sword_rot.scale = sr_scale

	sword_ready = false
	sword.do_attack()


func die():
	emit_signal('death')
	is_dead = true
	set_colliders_enabled(false)

	$AnimationPlayer.play("DeathFlash")
	$DeathSound.play()

	# wait for anim and sfx before reloading after death
	yield($DeathSound, "finished")
	yield($AnimationPlayer, "animation_finished")

	get_tree().reload_current_scene()


func on_sword_finish():
	sword_ready = true
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		if ConfigLoader.Instance.debug_no_dmg:
			return
		die()

