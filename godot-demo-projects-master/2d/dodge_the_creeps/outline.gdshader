shader_type canvas_item;

uniform bool enabled = false;
uniform vec4 outline_color : source_color = vec4(1.0, 0.9, 0.1, 1.0);
uniform float outline_width = 2.0;

void fragment() {
	if (enabled && texture(TEXTURE, UV).a < 0.1) {
		float surrounding_alpha = 0.0;
		for (int x = -2; x <= 2; x++) {
			for (int y = -2; y <= 2; y++) {
				vec2 sample_uv = UV + vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE * outline_width;
				surrounding_alpha = max(surrounding_alpha, texture(TEXTURE, sample_uv).a);
			}
		}
		if (surrounding_alpha > 0.1) {
			COLOR = outline_color;
		}
	}
}
