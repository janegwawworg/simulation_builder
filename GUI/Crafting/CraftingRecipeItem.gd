extends PanelContainer

const CUSTOM_PANEL_PROPERTY := "custom_styles/panel"

signal recipe_activated(recipe, output)

export var regular_style: StyleBoxFlat
export var highlight_style: StyleBoxFlat

onready var recipe_name := $MarginContainer/HBoxContainer/Label
onready var sprite := $MarginContainer/HBoxContainer/GUISprite


func _ready() -> void:
	var game_gui: float = ProjectSettings.get_setting("game_gui/inventory_size")
	var scale := game_gui / 100.0
	sprite.scale = Vector2(scale, scale)
	rect_min_size = Vector2(400, 0) * scale
	
	if regular_style:
		set(CUSTOM_PANEL_PROPERTY, regular_style)


func setup(name: String, texture: Texture, uses_region_rect: bool, region_rect: Rect2) -> void:
	recipe_name.recipe_name = name
	sprite.texture = texture
	sprite.region_enable = uses_region_rect
	sprite.region_rect = region_rect


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var recipe_filename: String = recipe_name.recipe_name
		var recipe: Dictionary = Recipes.Crafting[recipe_filename]

		emit_signal("recipe_activated", recipe, recipe_filename)


func _on_CraftingRecipe_mouse_entered():
	var recipe_filename: String = recipe_name.recipe_name
	Events.emit_signal("hover_over_recipe", recipe_filename, Recipes.Crafting[recipe_filename])
	set(CUSTOM_PANEL_PROPERTY, highlight_style)
	


func _on_CraftingRecipe_mouse_exited():
	Events.emit_signal("hover_over_entity", null)
	set(CUSTOM_PANEL_PROPERTY, regular_style)
