extends Node2D

@onready var pet_sprite : Sprite2D = $Icon
var velocity : Vector2 = Vector2(100, 100) # Initial velocity
@onready var window : Window = get_window()

# Scaling factor for DPI scaling (default is 1, adjust based on the display)
var dpi_scale: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set background to be transparent
	window.set_transparent_background(true)
	
	# Get the DPI scaling factor and adjust it
	dpi_scale = get_display_dpi_scale()

	# Set window to top-left corner of the primary screen
	var screen_position = DisplayServer.screen_get_position()
	window.position = Vector2(0, 0)

	# Get screen size and taskbar height
	var screen_size = DisplayServer.screen_get_usable_rect().size / dpi_scale  # Adjust for DPI scaling
	window.size = screen_size

	# Set viewport size (adjust for DPI scaling)
	get_viewport().size = screen_size

	print("Screen size:", screen_size)
	print("DPI scale:", dpi_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	handle_physics(delta)

# Bounce off corners of the screen (DVD screensaver style)
func handle_physics(delta):
	var pos = pet_sprite.global_position  # Using global position to track the position in the world
	var size = pet_sprite.texture.get_size() * dpi_scale  # Adjust sprite size based on DPI scaling
	var half_size = size / 2  # Since position is centered, calculate half the size for boundaries
	var screen_size = DisplayServer.screen_get_usable_rect().size / dpi_scale  # Adjust screen size for DPI scaling

	# Move the sprite, adjusted for DPI scaling
	pet_sprite.position += velocity * delta * dpi_scale

	# Bounce on horizontal edges (account for sprite's center)
	if pet_sprite.position.x - half_size.x < 0:
		velocity.x *= -1  # Reverse direction
		pet_sprite.position.x = half_size.x  # Snap back into the screen
	elif pet_sprite.position.x + half_size.x > screen_size.x:
		velocity.x *= -1
		pet_sprite.position.x = screen_size.x - half_size.x

	# Bounce on vertical edges (account for sprite's center)
	if pet_sprite.position.y - half_size.y < 0:
		velocity.y *= -1
		pet_sprite.position.y = half_size.y
	elif pet_sprite.position.y + half_size.y > screen_size.y:
		velocity.y *= -1
		pet_sprite.position.y = screen_size.y - half_size.y

	# Set passthrough for mouse events
	set_passthrough(pet_sprite)

# Set mouse passthrough for the sprite
func set_passthrough(sprite: Sprite2D):
	#var texture_center: Vector2 = sprite.texture.get_size() / 2
	#var dist = 1.0
	#var texture_corners: PackedVector2Array = [
		#sprite.global_position + texture_center * Vector2(-dist, -dist), # Top left corner
		#sprite.global_position + texture_center * Vector2(dist, -dist),  # Top right corner
		#sprite.global_position + texture_center * Vector2(dist, dist),   # Bottom right corner
		#sprite.global_position + texture_center * Vector2(-dist, dist)   # Bottom left corner
	#]

	 #get Area2D node
	var shape = sprite.get_node("Area2D").get_node("CollisionShape2D").shape as RectangleShape2D
	var rect: Rect2 = shape.get_rect()
	var texture_corners: PackedVector2Array = [
		sprite.global_position + rect.position,
		sprite.global_position + rect.position + Vector2(rect.size.x, 0),
		sprite.global_position + rect.position + rect.size,
		sprite.global_position + rect.position + Vector2(0, rect.size.y)
	]
	DisplayServer.window_set_mouse_passthrough(texture_corners)

# Function to get the DPI scale factor for the current display
func get_display_dpi_scale() -> float:
	var dpi = DisplayServer.screen_get_dpi()  # Get the DPI of the current screen
	var default_dpi = 96.0  # 96 DPI is considered "normal" on most systems
	return dpi / default_dpi  # Return the scaling factor based on the DPI

# When Sprite is clicked, change its color
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			# adjust shader parameter color
			$Icon.material.set_shader_parameter("color", Color(randf(), randf(), randf(), 1.0))
