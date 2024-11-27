shader_type canvas_item;

uniform vec4 cloud_color : source_color = vec4(1.0, 1.0, 1.0, 0.5);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    COLOR = texture_color * cloud_color;
}