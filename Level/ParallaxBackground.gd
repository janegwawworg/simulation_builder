extends ParallaxBackground

export (Texture) var background
export (Vector2) var position

onready var _sprite := $ParallaxLayer/Sprite


func _ready() -> void:
	_sprite.texture = background
	_sprite.position = position
