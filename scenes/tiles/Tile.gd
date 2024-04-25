extends Area2D

class_name Tile1

var inside = false

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inside and Input.is_action_just_pressed("leftMB"):
		emit_signal("clicked")
		

func _on_area_2d_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	inside = true


func _on_area_2d_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	inside = false


func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	inside = true


func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	inside = false
