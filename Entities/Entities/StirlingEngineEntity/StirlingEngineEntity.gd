extends Entity

const BOOTUP := 0.6
const SHUTDOWN := 3
var available_fuel := 0.0
var last_max_fuel := 0.0

onready var _animate_player := $AnimationPlayer
onready var _tween := $Tween
onready var _shaft := $PistonShaft
onready var _power_source := $PowerSource
onready var gui := $GUIComponent


func _efficiency_update(value: float) -> void:
	_power_source.efficiency = value
	Events.emit_signal("info_updated", self)


func get_info() -> String:
	return "%.1f j/s" % _power_source.get_effective_power()


func _setup_work() -> void:
	if not _animate_player.is_playing() and (gui.gui.fuel or available_fuel > 0.0):
		_animate_player.play("work")

		_tween.interpolate_property(_animate_player, "playback_speed", 0, 1, BOOTUP)
		_tween.interpolate_property(_shaft, "modulate", Color.white, Color(0.5, 1, 0.5), BOOTUP)
		_tween.interpolate_method(self, "_efficiency_update", 0.0, 1.0, BOOTUP)
		_tween.start()
		_consume_fuel(0.0)
	elif (_animate_player.is_playing() and _animate_player.current_animation == "work"
		and not (gui.gui.fuel or available_fuel > 0.0)):
		var work_animation: Animation = _animate_player.get_animation(
			_animate_player.current_animation
		)
		work_animation.loop = false
		yield(_animate_player, "animation_finished")
		
		_animate_player.play("shutdown")
		_animate_player.playback_speed = 1.0
		_tween.interpolate_property(_shaft, "modulate", _shaft.modulate, Color(1, 1, 1), SHUTDOWN)
		_tween.interpolate_method(self, "_efficiency_update", 1, 0, SHUTDOWN)
		_tween.start()


func _consume_fuel(amount: float) -> void:
	available_fuel = max(available_fuel - amount, 0.0)

	if available_fuel <= 0.0 and gui.gui.fuel:
		last_max_fuel = Recipes.Fuels[Library.get_entity_name_from(gui.gui.fuel)]
		available_fuel = last_max_fuel

		gui.gui.fuel.stack_count -= 1
		if gui.gui.fuel.stack_count == 0:
			gui.gui.fuel.queue_free()
			gui.gui.fuel = null
		else:
			gui.gui.update_lables()
	else:
		_setup_work()
	gui.gui.set_fuel((available_fuel / last_max_fuel) if last_max_fuel > 0.0 else 0.0)


func _on_PowerSource_power_updated(power_draw, delta) -> void:
	_consume_fuel(delta)


func _on_GUIComponent_gui_status_changed():
	_setup_work()
