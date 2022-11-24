extends Camera2D

# Starting range of possible offsets using random values
export var RANDOM_SHAKE_STRENGTH: float = 30.0
# Multiplier for lerping shake strength to zero
export var SHAKE_DECAY_RATE: float = 5.0

var shake_strength: float = 0.0
onready var rng = RandomNumberGenerator.new()
onready var player = get_node('/root/World/Player')

func _ready():
	rng.randomize()
	player.connect('bullet_shot', self, 'apply_shake')
	player.connect('death', self, 'apply_shake')

func _process(delta):
	shake_strength = lerp(shake_strength, 0, SHAKE_DECAY_RATE * delta)
	self.offset = get_rand_offset()

func apply_shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH

func get_rand_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
