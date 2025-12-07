shader_type canvas_item;
render_mode world_vertex_coords;

group_uniforms Squiggle;
/**
 * Noise texture scale
 * By default, the noise texture's size in world coordinates is set by its resolution
*/
uniform vec2 scale = vec2(1.0);
uniform float strength = 1.0;
/**
 * Number of squiggle frames per second
*/
uniform float fps = 6.0;
uniform sampler2D noise : filter_linear, repeat_enable;
group_uniforms;

group_uniforms Effect;
uniform float shine_num = 8;
uniform float rotation_speed = 3;
uniform float light_magnitude = 2;
uniform float filter_distence: hint_range(0, 1) = 1.0;
uniform float filter_magnitude: hint_range(0, 1) = 1.0;
uniform float filter_minv: hint_range(0, 1) = 0.75;
uniform float cut_inner_radius: hint_range(0, 1) = 0.1;
uniform vec4 color : source_color = vec4(1,1,1,1);
group_uniforms;

group_uniforms Noise_Effect;
uniform sampler2D NOISE : source_color;
uniform sampler2D NOISE2 : source_color;
uniform vec2 NOISE_speed = vec2(0,0);
uniform float NOISE_magnitude: hint_range(0, 1) = 0.0;
group_uniforms;

group_uniforms Blur;
uniform float blur_amount: hint_range(0, 0.05) = 0.005;
group_uniforms;

varying vec4 modulate;
varying vec2 noise_uv;

void vertex() {
	modulate = COLOR;
	// Use world coordinates for scale-independent squiggles, offset by position to keep pattern attached to object
	noise_uv = (VERTEX - MODEL_MATRIX[3].xy) / (vec2(textureSize(noise, 0)) * scale);
}

// Use irrational constants for unique squiggles every frame
#define offset_multiplier vec2(PI, E)

vec4 calculate_pixel(vec2 sample_uv) {
	// Apply squiggle distortion
	vec2 noise_offset = vec2(floor(TIME * fps)) * offset_multiplier;
	float noise_sample = texture(noise, noise_uv + noise_offset).r * 4.0 * PI;
	vec2 direction = vec2(cos(noise_sample), sin(noise_sample));
	vec2 squiggle_uv = sample_uv + direction * strength * 0.005;
	
	// Calculate effect
	float ang = atan((squiggle_uv.x-0.5)/(squiggle_uv.y-0.5));
	vec4 mixa = vec4(1,1,1,1);
	vec2 pos = vec2(squiggle_uv.x + NOISE_speed.x*TIME - floor(squiggle_uv.x + NOISE_speed.x*TIME),
					squiggle_uv.y + NOISE_speed.y*TIME - floor(squiggle_uv.y + NOISE_speed.y*TIME));
	mixa = smoothstep(0.0,1.0,texture(NOISE, pos).rgba);
	
	vec4 pixel_color = color*vec4(abs(sin(ang*shine_num*0.5 + TIME*rotation_speed)))*(1.0-NOISE_magnitude) + NOISE_magnitude*mixa;
	pixel_color.a = ((1.0 - filter_distence*0.5) - distance(squiggle_uv, vec2(0.5,0.5))*filter_magnitude)*light_magnitude;
	
	if ((distance(squiggle_uv, vec2(0.5,0.5)) > 1.0/2.0) || 
		(distance(squiggle_uv, vec2(0.5,0.5)) < cut_inner_radius) || 
		((pixel_color.r < filter_minv) && (pixel_color.g < filter_minv) && (pixel_color.b < filter_minv))) {
		return vec4(0.0);
	}
	
	return pixel_color * modulate;
}

void fragment() {
	// Gaussian blur kernel (9x9)
	vec4 blur_color = vec4(0.0);
	
	// Gaussian weights for 9x9 kernel (simplified, normalized)
	float kernel[5] = float[](0.06136, 0.24477, 0.38774, 0.24477, 0.06136);
	
	float total_weight = 0.0;
	
	for (int x = -4; x <= 4; x++) {
		for (int y = -4; y <= 4; y++) {
			vec2 offset = vec2(float(x), float(y)) * blur_amount;
			vec2 sample_uv = UV + offset;
			
			// Calculate Gaussian weight
			float weight = kernel[abs(x)] * kernel[abs(y)];
			
			vec4 sample_color = calculate_pixel(sample_uv);
			
			blur_color += sample_color * weight;
			total_weight += weight;
		}
	}
	
	if (total_weight > 0.0) {
		COLOR = blur_color / total_weight;
	} else {
		COLOR.rgba = vec4(0.0);
	}
}