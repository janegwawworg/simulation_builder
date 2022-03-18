extends Node
class_name PowerReceiver

signal received_power(amount, delta)

export var power_required := 10.0

export (Types.Direction, FLAGS) var input_direction := 15

var efficiency := 0.0

func get_effective_power() -> float:
	return efficiency * power_required
