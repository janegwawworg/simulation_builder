extends Reference
class_name PowerSystem

var power_sources := {}

var power_receivers := {}

var power_movers := {}

var paths := []

var cells_travelled := []

var receivers_already_provided := {}

func _init() -> void:
	Events.connect("entity_placed", self, "_on_entity_placed")
	Events.connect("entity_remove", self, "_on_entity_removed")
	Events.connect("systems_ticked", self, "_on_systems_ticked")
	
	
func _get_power_source_from(entity: Node) -> PowerSource:
	for child in entity.get_children():
		if child is PowerSource:
			return child
	return null
	

func _get_power_receiver_from(entity: Node) -> PowerReceiver:
	for child in entity.get_children():
		if child is PowerReceiver:
			return child
	return null
	
	
func _on_entity_placed(entity, cell: Vector2) -> void:
	var retrace := false
	
	if entity.is_in_group(Types.POWER_SOURCES):
		power_sources[cell] = _get_power_source_from(entity)
		retrace = true
		
	if entity.is_in_group(Types.POWER_RECEIVERS):
		power_receivers[cell] = _get_power_receiver_from(entity)
		retrace = true
		
	if entity.is_in_group(Types.POWER_MOVERS):
		power_movers[cell] = entity
		retrace = true
		
	if retrace:
		_retrace_paths()
		
		
func _on_entity_removed(_entity, cell: Vector2) -> void:
	var retrace := power_sources.erase(cell)
	retrace = power_receivers.erase(cell) or retrace
	retrace = power_movers.erase(cell) or retrace
	
	if retrace:
		_retrace_paths()
		
		
func _retrace_paths() -> void:
	pass
