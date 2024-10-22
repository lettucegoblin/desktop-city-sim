extends Node2D

@export var noise_texture: FastNoiseLite  # Exported noise generator for controlling prefab placement
@export var lot_prefabs: Array[PackedScene]  # Array of lot prefabs to choose from (towers, parks, etc.)

@export var noise_scale: float = 1.0  # Scale for noise generation (affects how spread out the variations are)

func _ready():
	var scene_width = get_viewport_rect().size.x
	var scene_height = get_viewport_rect().size.y

	var i: int = 0
	while true:
		var lot = _generate_lot(i)
		var lot_width = lot.get_node("Sprite2D").region_rect.size.x
		

		lot.position = Vector2(i * lot_width, scene_height)  # Adjust position based on screen width and lot width
		if lot.position.x + lot_width > scene_width:
			break
		add_child(lot)
		i += 1

# Function to generate a lot based on noise texture
func _generate_lot(index: int) -> Node2D:
	# Use noise texture to decide which prefab to instantiate
	var noise_value = noise_texture.get_noise_1d(index * noise_scale)
	
	# Map noise_value (-1.0 to 1.0) to array indices (0 to lot_prefabs.size() - 1)
	var lot_index = int(clamp((noise_value + 1.0) * 0.5 * lot_prefabs.size(), 0, lot_prefabs.size() - 1))

	# Instantiate the chosen lot from the prefabs array
	return lot_prefabs[lot_index].instantiate()
