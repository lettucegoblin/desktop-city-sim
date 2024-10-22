extends Window

@export var height = 100; # 100px

func get_taskbar_height():
	return DisplayServer.screen_get_size().y - DisplayServer.screen_get_usable_rect().size.y

func init_window():
	# set signal on window size change to update the BoxContainer size
	#connect("resized", Callable(self, "update_box_container_size"))
	size.y = DisplayServer.screen_get_size().y - get_taskbar_height()
	transparent = true
	transparent_bg = true
	var BoxContainerPackedVector2Array : PackedVector2Array = PackedVector2Array([Vector2(0, 0), Vector2(0, $BoxContainer.size.y), Vector2($BoxContainer.size.x, $BoxContainer.size.y), Vector2($BoxContainer.size.x, 0)])

	DisplayServer.window_set_mouse_passthrough(BoxContainerPackedVector2Array, get_window_id())
	DisplayServer.window_set_mouse_passthrough(BoxContainerPackedVector2Array)
	print(get_window_id())
	#size.y = height
	#position.y = DisplayServer.screen_get_size().y - get_taskbar_height() - size.y
	#size.x = DisplayServer.screen_get_size().x

func update_box_container_size():
	$BoxContainer.size.x = size.x
	$BoxContainer.size.y = height

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_window()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
