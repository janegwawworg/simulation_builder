extends PanelContainer

const OFFSET := Vector2(25, -25)

var current_entity: Node

onready var _label := $MarginContainer/Label


func _ready() -> void:
	set_as_toplevel(true)
	
	Events.connect("hover_over_entity", self, "_on_hover_over_entity")
	Events.connect("info_updated", self, "_on_info_updated")
	Events.connect("hover_over_recipe", self, "_on_hovered_over_recipe")
	hide()
	
	
func _process(delta) -> void:
	rect_global_position = get_global_mouse_position() + OFFSET


func _on_hover_over_entity(entity: Node) -> void:
	if not current_entity == entity:
		current_entity = entity

	if not entity:
		_label.text = ""
		hide()
	else:
		_set_info(entity)
		set_deferred("rect_size", Vector2.ZERO)
	
	
func _on_info_updated(entity: Node) -> void:
	if current_entity and entity == current_entity:
		_set_info(entity)
		set_deferred("rect_size", Vector2.ZERO)
	
	
func _set_info(entity: Node) -> void:
	var entity_filename := Library.get_entity_name_from(entity).capitalize()
	var output := entity_filename

	if entity is BlueprintEntity:
		output += "\n%s" % entity.description
	else:
		if entity.has_method("get_info"):
			var info: String = entity.get_info()
			if not info.empty():
				output += "\n%s" % info
				
	_label.text = output
	show()


func _on_hovered_over_recipe(output: String, recipe: Dictionary) -> void:
	var blueprint: BlueprintEntity = Library.blueprints[output].instance()
	_set_info(blueprint)
	
	blueprint.free()
	
	_label.text = "%sx %s" % [recipe.amount, _label.text]
	
	var inputs: Dictionary = recipe.inputs
	for input in inputs.keys():
		_label.text += "\n   %sx %s" % [inputs[input], input.capitalize()]
		
	set_deferred("rect_size", Vector2.ZERO)
