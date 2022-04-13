extends MarginContainer


func _on_Button_pressed():
	call_deferred("_change_scene", "res://Systems/Simulation.tscn")


func _on_Button3_pressed():
	call_deferred("_change_scene", "res://GUI/Menu/LevelsMenu.tscn")


func _on_Button4_pressed():
	get_tree().quit()


func _on_Button2_pressed():
	Library.load_game()


func _change_scene(path: String) -> void:
	get_tree().change_scene(path)
