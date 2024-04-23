shader_type canvas_item;

uniform sampler2D noise_texture : hint_black;
uniform float intensity : hint_range(0, 1) = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    vec4 noise = texture(noise_texture, UV);
    
    // Multiply the noise color with the object's color and the intensity
    color.rgb *= noise.rgb * intensity;
    
    COLOR = color;
}
