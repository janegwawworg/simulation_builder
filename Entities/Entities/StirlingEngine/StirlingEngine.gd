extends Entity

const BOOTUP := 0.3
const BOOTBACK := 0.6

onready var _animate_player := $AnimationPlayer
onready var _tween := $Tween
onready var _shaft := $PistonShaft


func _ready() -> void:
	_animate_player.play("work")
	
	_tween.interpolate_property(_animate_player, "playback_speed", 0, 1, BOOTUP)
	_tween.interpolate_property(
		_shaft, "modulate", Color.white, Color(0.5, 1, 0.5), BOOTUP
	)
	_tween.start()
