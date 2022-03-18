extends Reference
class_name EntityTracker

var _entities := {}


func entity_placed(entity, cell: Vector2) -> void:
	if _entities.has(cell):
		return
	
	_entities[cell] = entity
	Events.emit_signal("entity_placed", entity, cell)
	
	
func entity_remove(cell) -> void:
	if not _entities.has(cell):
		return
	
	var entity = _entities[cell]
	var _result := _entities.erase(cell)
	Events.emit_signal("entity_remove", entity, cell)
	entity.queue_free()
	
	
func is_cell_occupied(cell) -> bool:
	return _entities.has(cell)
	
	
func get_entity(cell: Vector2) -> Node2D:
	if _entities.has(cell):
		return _entities[cell]
	else:
		return null
