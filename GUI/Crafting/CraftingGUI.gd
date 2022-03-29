extends MarginContainer

const CraftingItem := preload("CraftingRecipe.tscn")

var gui: Control

onready var items := $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer


func setup(_gui: Control) -> void:
	gui = _gui
	
	
func update_recipes() -> void:
	for child in items.get_children():
		child.queue_free()
		
	for output in Recipes.Crafting.keys():
		var recipe: Dictionary = Recipes.Crafting[output]
		
		var can_craft := true
		
		for input in recipe.inputs.keys():
			if not gui.is_in_inventory(input, recipe.inputs[input]):
				can_craft = false
				break
				
		if not can_craft:
			continue
			
		var temp: BlueprintEntity = Library.blueprints[output].instance()
		
		var item := CraftingItem.instance()
		items.add_child(item)
		
		var sprite: Sprite = temp.get_node("Sprite")
		
		item.setup(
			Library.get_entity_name_from(temp),
			sprite.texture,
			sprite.region_enabled,
			sprite.region_rect
		)
		item.connect("recipe_activated", self, "_on_recipe_activated")
		temp.free()
		
	Events.emit_signal("hover_over_entity", null)


func _on_recipe_activated(recipe: Dictionary, output: String) -> void:
	for input in recipe.inputs.keys():
		var panels: Array = gui.find_panels_with(input)
		var count: int = recipe.inputs[input]
		
		for panel in panels:
			if panel.held_item.stack_count >= count:
				panel.held_item.stack_count -= count
				count = 0
			else:
				count -= panel.held_item.stack_count
				panel.held_item.stack_count = 0
				
			if panel.held_item.stack_count == 0:
				panel.held_item.queue_free()
				panel.held_item = null
				
			panel._update_label()
			
			if count == 0:
				break
	var item: BlueprintEntity = Library.blueprints[output].instance()
	item.stack_count = recipe.amount
	
	gui.add_to_inventory(item)
