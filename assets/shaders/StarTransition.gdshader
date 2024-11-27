shader_type canvas_item;

uniform sampler2D mask;
uniform float scale : hint_range(0.0, 1.0, 0.1);
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	float s = scale == 0.0 ? 0.0 : pow(2.0, 10.0 * scale - 10.0);
	s *= 75.0;
	int cutoff = int(s / 78.0);
	vec2 centered_uv = (UV - center) * s + center;
	vec4 mask_color = texture(mask, centered_uv);
	COLOR.a = 1.0 - mask_color.a + float(cutoff);
}