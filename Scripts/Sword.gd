extends KinematicBody2D

signal enemy_hit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Swing_sound = $AudioStreamPlayer2D
onready var Swing_anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	Swing_sound.play()
	Swing_anim.play("attack")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

