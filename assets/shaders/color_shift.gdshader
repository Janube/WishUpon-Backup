shader_type canvas_item;

uniform vec4 shift_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float shift_amount : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec3 shifted = mix(texture_color.rgb, shift_color.rgb, shift_amount);
    COLOR = vec4(shifted, texture_color.a);
}