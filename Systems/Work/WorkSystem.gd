extends Reference
class_name WorkSystem

var workers := {}


func _init() -> void:
	Events.connect("systems_ticked", self, "_on_systems_ticked")
	Events.connect("entity_placed", self, "_on_entity_placed")
	Events.connect("entity_remove", self, "_on_entity_removed")


func _on_systems_ticked(delta: float) -> void:
	for worker in workers.keys():
		workers[worker].work(delta)


func _on_entity_placed(entity, cell: Vector2) -> void:
	if entity.is_in_group(Types.WORKERS):
		workers[cell] = _get_work_component_from(entity)


func _get_work_component_from(entity) -> WorkComponent:
	for child in entity.get_children():
		if child is WorkComponent:
			return child

	return null


func _on_entity_removed(_entity, cell: Vector2) -> void:
	var _erased := workers.erase(cell)
