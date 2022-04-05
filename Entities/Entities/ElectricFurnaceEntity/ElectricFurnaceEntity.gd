extends FurnaceEntity

onready var power := $PowerReceiver


func _ready() -> void:
	power.efficiency = 1.0


func _set_initial_speed() -> void:
	work.work_speed = 0.0


func _consume_fuel(amount: float) -> void:
	pass


func _on_PowerReceiver_received_power(amount: float, delta: float) -> void:
	var new_work_speed: float = amount / power.power_required

	gui.gui.update_speed(new_work_speed)
	work.work_speed = new_work_speed
	
	if amount > 0:
		available_fuel = 1.0
	_setup_work()
	available_fuel = 0


func _on_GUICompoent_gui_opened() -> void:
	if work.is_enabled and work.work_speed > 0.0:
		gui.gui.work(work.current_recipe.time)
		gui.gui.update_speed(work.work_speed)
		gui.gui.seek(work.current_recipe.time - work.available_work)
