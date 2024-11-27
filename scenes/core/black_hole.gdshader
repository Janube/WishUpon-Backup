shader_type canvas_item;
uniform sampler2D screen_tex: hint_screen_texture;
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float falloff : hint_range(0.0, 1.0) = 0.1;
uniform sampler2D curve;
uniform float strength : hint_range(-1, 1) = 0.5;

void fragment() {
	vec2 vecToCenter = vec2(0.5, 0.5) -UV;
	float distToCenter = length(vecToCenter);
	float blendFactor = smoothstep(radius, radius - falloff, distToCenter);
	float curveVal = texture(curve, vec2(distToCenter)).r;
	vec2 diff = normalize(vecToCenter) * 0.6 * curveVal;
	COLOR = mix(textureLod(screen_tex, SCREEN_UV, 0.0), textureLod(screen_tex, SCREEN_UV - diff, 0.0), blendFactor);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
