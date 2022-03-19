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
	paths.clear()
	
	for source in power_sources:
		cells_travelled.clear()
		
		var path := _trace_path_from(source, [source])
		
		paths.push_back(path)
		
		
func _trace_path_from(cell: Vector2, path: Array) -> Array:
	cells_travelled.push_back(cell)
	
	var direction := 15
	if power_sources.has(cell):
		direction = power_sources[cell].output_direction
		
	var receivers := _find_neighbors_in(cell, power_receivers, direction)
	for receiver in receivers:
		if not receiver in cells_travelled and not receiver in path:
			var combined_direction := _combine_directions(receiver, cell)
			var power_receiver: PowerReceiver = power_receivers[receiver]
			if (
				(combined_direction & Types.Direction.RIGHT != 0
					and power_receiver.input_direction & Types.Direction.LEFT == 0)
				or (combined_direction & Types.Direction.DOWN != 0
					and power_receiver.input_direction & Types.Direction.UP == 0)
				or (combined_direction & Types.Direction.LEFT != 0
					and power_receiver.input_direction & Types.Direction.RIGHT == 0)
				or (combined_direction & Types.Direction.UP != 0
					and power_receiver.input_direction & Types.Direction.DOWN == 0)
			):
				continue
				
			path.push_back(receiver)
			
	var movers := _find_neighbors_in(cell, power_movers, direction)
	
	for mover in movers:
		if not mover in cells_travelled:
			path = _trace_path_from(mover, path)
	
	return path


func _combine_directions(receiver: Vector2, cell: Vector2) -> int:
	if receiver.x < cell.x:
		return Types.Direction.LEFT
	elif receiver.x > cell.x:
		return Types.Direction.RIGHT
	elif receiver.y < cell.y:
		return Types.Direction.UP
	elif receiver.y > cell.y:
		return Types.Direction.DOWN
		
	return 0


func _find_neighbors_in(
	cell: Vector2, 
	collection: Dictionary, 
	output_directions: int = 15
) -> Array:
	var neighbors := []
	for neighbor in Types.NEIGHBORS.keys():
		if neighbor & output_directions != 0:
			var key: Vector2 = cell + Types.NEIGHBORS[neighbor]
			
			if collection.has(key):
				neighbors.push_back(key)
				
	return neighbors


func _on_systems_ticked(delta: float) -> void:
	receivers_already_provided.clear()
	
	for path in paths:
		var power_source: PowerSource = power_sources[path[0]]
		
		var source_power := power_source.get_effective_power()
		
		var remaining_power := source_power
		
		var power_draw := 0.0
		
		for cell in path.slice(1, path.size()-1):
			if not power_receivers.has(cell):
				continue
				
			var power_receiver: PowerReceiver = power_receivers[cell]
			var power_required := power_receiver.get_effective_power()
			
			if receivers_already_provided.has(cell):
				var receiver_total: float = receivers_already_provided[cell]
				if receiver_total >= power_required:
					continue
				else:
					power_required -= receiver_total
					
			power_receiver.emit_signal(
				"received_power", min(remaining_power, power_required), delta
				)
				
			power_draw = min(source_power, power_draw + power_required)
			
			if not receivers_already_provided.has(cell):
				receivers_already_provided[cell] = min(remaining_power, power_required)
			else:
				receivers_already_provided[cell] += min(remaining_power, power_required)
				
			remaining_power = max(0, remaining_power - power_required)
			
			if remaining_power == 0:
				break
				
		power_source.emit_signal("power_updated", power_draw, delta)
		print(remaining_power)
