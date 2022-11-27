extends Area2D

class_name Sword

signal enemy_hit
signal sword_finish

onready var Swing_anim = $AnimationPlayer

var active: bool = false

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_finish")
	$CollisionShape2D.disabled = true
	$Sprite.visible = false


func _on_anim_finish(anim_name: String):
	# queue_free()
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	emit_signal("sword_finish")
	pass


func do_attack() -> void:
	$CollisionShape2D.disabled = false
	$Sprite.visible = true
	$SfxSwordSwing.play()
	Swing_anim.play("attack")


func set_active(active: bool) -> void:
	pass
