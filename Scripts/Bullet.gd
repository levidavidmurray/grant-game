extends RigidBody2D

signal enemy_hit

# destroy bullet after lifetime (in the event it doesn't collide and goes off screen)
export var bullet_lifetime: float = 1.5

onready var timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = bullet_lifetime
	timer.one_shot = true
	timer.start()
	
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout() -> void:
	queue_free()
	


