extends PanelContainer

onready var recipe_name := $MarginContainer/HBoxContainer/Label
onready var sprite := $MarginContainer/HBoxContainer/GUISprite


func setup(name: String, texture: Texture, uses_region_rect: bool, region_rect: Rect2) -> void:
	recipe_name.recipe_name = name
	sprite.texture = texture
	sprite.region_enable = uses_region_rect
	sprite.region_rect = region_rect


func _on_CraftingRecipe_mouse_entered():
	Events.emit_signal("hover_over_entity", null)


func _on_CraftingRecipe_mouse_exited():
	var recipe_filename: String = recipe_name.recipe_name
	Events.emit_signal("hover_over_recipe", recipe_filename, Recipes.Crafting[recipe_filename])
