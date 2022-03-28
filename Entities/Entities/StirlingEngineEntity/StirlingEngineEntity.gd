extends Entity

const BOOTUP := 0.3
const BOOTBACK := 0.6

onready var _animate_player := $AnimationPlayer
onready var _tween := $Tween
onready var _shaft := $PistonShaft
onready var _power_source := $PowerSource


func _ready() -> void:
	_animate_player.play("work")
	
	_tween.interpolate_property(_animate_player, "playback_speed", 0, 1, BOOTUP)
	_tween.interpolate_property(
		_shaft, "modulate", Color.white, Color(0.5, 1, 0.5), BOOTUP
	)
	#_tween.interpolate_property(_power_source, "efficiency", 0, 1, BOOTUP)
	_tween.interpolate_method(self, "_efficiency_update", 0.0, 1.0, BOOTUP)
	_tween.start()
	
	
func _efficiency_update(value: float) -> void:
	_power_source.efficiency = value
	Events.emit_signal("info_updated", self)


func get_info() -> String:
	return "%.1f j/s" % _power_source.get_effective_power()
