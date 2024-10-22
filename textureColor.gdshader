shader_type canvas_item;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// if pixel is transparent, discard it
	if (COLOR.a < 0.1) {
		discard;
	}

	float uv_cutoff = 0.05;
	if (UV.x < uv_cutoff || UV.x > 1.0 - uv_cutoff || UV.y < uv_cutoff || UV.y > 1.0 - uv_cutoff) {
		//discard;
	}
	// Replace the fragment color with the color uniform
	COLOR = vec4(color.rgb, COLOR.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
