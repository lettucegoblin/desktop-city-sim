shader_type canvas_item;

uniform float threshold : hint_range(0.0, 1.0) = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	// if color is white then make it transparent within a threshold

	if (COLOR.r > 1.0 - threshold && COLOR.g > 1.0 - threshold && COLOR.b > 1.0 - threshold) {
		COLOR.a = 0.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
