extends Entity
class_name FurnaceEntity

var available_fuel := 0.0
var last_max_fuel := 0.0

onready var gui := $GUIComponent
onready var work := $WorkComponent
onready var animation := $AnimationPlayer


func _ready() -> void:
	_set_initial_speed()


func _set_initial_speed() -> void:
	work.work_speed = 1.0


func get_info() -> String:
	if work.is_enabled:
		return (
			"Smelting: %s into %s\nTime left: %ss" %
			[
				Library.get_entity_name_from(gui.gui.input),
				Library.get_entity_name_from(work.current_output),
				stepify(work.available_work, 0.1)
			]
		)
	else:
		return ""


func _setup_work() -> void:
	if (gui.gui.fuel or available_fuel > 0.0) and gui.gui.input and work.available_work <= 0.0:
		var input_id : String = Library.get_entity_name_from(gui.gui.input)
		
		if work.setup_work({input_id: gui.gui.input.stack_count}, Recipes.Smelting):
			work.is_enabled = (
				not gui.gui.output_panel.held_item
				or (
					Library.get_entity_name_from(work.current_output)
					== Library.get_entity_name_from(gui.gui.output_panel.held_item)
				)
			)
			gui.gui.work(work.current_recipe.time)
			
			if available_fuel <= 0.0:
				_consume_fuel(0.0)
	
	elif work.available_work > 0.0 and not gui.gui.input:
		work.available_work = 0.0
		work.is_enabled = false
		gui.gui.abort()
	
	elif work.available_work <= 0.0:
		work.is_enabled = false


func _consume_fuel(amount: float) -> void:
	available_fuel = max(available_fuel - amount, 0.0)

	if available_fuel <= 0.0 and gui.gui.fuel:
		last_max_fuel = Recipes.Fuels[Library.get_entity_name_from(gui.gui.fuel)]
		available_fuel = last_max_fuel

		gui.gui.fuel.stack_count -= 1
		if gui.gui.fuel.stack_count == 0:
			gui.gui.fuel.queue_free()
			gui.gui.fuel = null
		
		gui.gui.update_labels()

	work.is_enabled = available_fuel > 0.0
	gui.gui.set_fuel((available_fuel / last_max_fuel) if last_max_fuel > 0.0 else 0.0)


func _consume_input() -> bool:
	if gui.gui.input:
		var consumption_count: int = work.current_recipe.inputs[Library.get_entity_name_from(
			gui.gui.input
		)]
		
		if gui.gui.input.stack_count >= consumption_count:
			gui.gui.input.stack_count -= consumption_count
			if gui.gui.input.stack_count == 0:
				gui.gui.input.queue_free()
				gui.gui.input == null
			
			gui.gui.update_labels()
			return true
	else:
		gui.gui.abort()
	
	return false


func _on_GUIComponent_gui_opened():
	gui.gui.set_fuel(available_fuel / last_max_fuel if last_max_fuel else 0.0)
	if work.is_enabled:
		gui.gui.work(work.current_recipe.time)
		gui.gui.seek(work.current_recipe.time - work.available_work)


func _on_GUIComponent_gui_status_changed():
	_setup_work()


func _on_WorkComponent_work_accomplished(amount: float) -> void:
	_consume_fuel(amount)
	Events.emit_signal("info_updated", self)


func _on_WorkComponent_work_done(output: BlueprintEntity) -> void:
	if _consume_input():
		gui.gui.grab_output(output)
		_setup_work()
	else:
		output.queue_free()
		work.is_enabled = false
	Events.emit_signal("info_updated", self)


func _on_WorkComponent_work_enabled_changed(enabled: bool):
	if enabled:
		animation.play("work")
	else:
		animation.play("shutdown")
