shader_type canvas_item;

float remap(float value, float in_min, float in_max)
{
	return (value - in_min) / (in_max - in_min);
}

uniform vec2 mouse_position = vec2(0.5, 0.5);
uniform vec4 wave_color: source_color = vec4(1.0, 2.0, 4.0, 1.0);
uniform float wave_transparency: hint_range(0.0, 1.0) = 1.0;

mat2 rotate2D(float r) {
    // 2D Rotation matrix	
    return mat2(vec2(cos(r), sin(r)), vec2(-sin(r), cos(r)));
}

void fragment() {
    // Texture coordinates
    vec2 uv = (FRAGCOORD.xy / TEXTURE_PIXEL_SIZE.y) * 0.0008;
    // Initial color
    vec3 col = vec3(0.0);
    // Time
    float t = TIME;
    // Variables for noise calc
    vec2 n = vec2(0.0), q;
    vec2 N = vec2(0.0);
    // Initial position
    vec2 p = uv + sin(t*0.1/10.0);
    // Initial scale
    float S = 5.0;
    // Matrix rotation
    mat2 m = rotate2D(1.0 - (mouse_position.x * 0.001));
    // Noise generation
    for (float j = 0.0; j < 30.0; j++) {
        // Rotate position+vector
        p *= m;
        n *= m;
        // Calculate noise
        q = p * 1.8  * S + j + n+ t;
        n += sin(q) * p; //Remove * p for neurons instead of clouds
        N += cos(q) / S;
        // Scale multiplier
        S *= 1.7;
    }

    // Evitar divisiones por cero
    float lengthN = max(length(N), 0.001);
    // Calculate final color
    col = wave_color.rgb * pow((N.x + N.y + 0.4) + 0.002 / lengthN, 2.1);
	// col = pow(max(vec3(0),(N.x+N.y+.5)*.1*wave_color.rgb+.003/length(N)),vec3(.65));
    COLOR = vec4(col, wave_transparency);
	
	float fade_value = 1. - (distance(UV, vec2(.5,.5)) * 1.);
	fade_value = remap(fade_value, 0.6,0.8
	);
	COLOR.a = mix(0.,1., fade_value);
}