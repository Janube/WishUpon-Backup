shader_type canvas_item;

uniform vec4 bg_color = vec4(1.0, 0.0, 0.0, 1.0);

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    float size = 100.0;
    float prob = 0.95; //how many big stars
    vec2 pos = floor(1.0 / size * FRAGCOORD.xy);
    float color = 0.0;
    float starValue = rand(pos);

    if (starValue > prob) {
        vec2 center = size * pos + vec2(size, size) * 0.1;
        float t = 0.9 + 0.2 * sin(TIME * 4.0 + (starValue - prob) / (1.0 - prob) * 45.0); //Time * value = dimming time
        color = 1.0 - distance(FRAGCOORD.xy, center) / (0.5 * size); //Big star size
        color = color * t / (abs(FRAGCOORD.y - center.y)) * t / (abs(FRAGCOORD.x - center.x));
    } else if (rand(SCREEN_UV.xy / 20.0) > 0.996) { //Smaller star density
        float r = rand(SCREEN_UV.xy);
        color = r * (0.55 * sin(TIME * (r * 5.0) + 720.0 * r) + 0.5); //Last number small star brightness
    }

    COLOR = vec4(vec3(color), 1.4) + bg_color; //Number is shader brightness
}
