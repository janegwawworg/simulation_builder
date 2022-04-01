extends Entity

onready var _animate := $AnimationPlayer




func _on_GUIComponent_gui_closed():
	_animate.play("close")


func _on_GUIComponent_gui_opened():
	_animate.play("open")
