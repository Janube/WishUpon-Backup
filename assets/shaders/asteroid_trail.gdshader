shader_type canvas_item;

uniform vec4 trail_color : source_color = vec4(1.0, 0.5, 0.0, 0.5);
uniform float trail_length : hint_range(0.0, 1.0) = 0.5;
uniform float trail_density : hint_range(0.0, 1.0) = 0.5;
uniform vec2 direction = vec2(1.0, 0.0);

void fragment() {
    vec2 uv = UV;
    
    // Rotate UV based on direction
    float angle = atan(direction.y, direction.x);
    mat2 rotation_matrix = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
    vec2 rotated_uv = (uv - 0.5) * rotation_matrix + 0.5;
    
    // Create trail effect
    float trail = smoothstep(trail_length, 0.0, rotated_uv.x);
    trail *= smoothstep(0.0, trail_density, fract(rotated_uv.y * 10.0 + TIME * 2.0));
    
    // Mix trail with original texture
    vec4 texture_color = texture(TEXTURE, uv);
    COLOR = mix(texture_color, trail_color, trail * trail_color.a * (1.0 - texture_color.a));
}