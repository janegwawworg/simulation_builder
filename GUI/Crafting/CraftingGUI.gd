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
		temp.free()
