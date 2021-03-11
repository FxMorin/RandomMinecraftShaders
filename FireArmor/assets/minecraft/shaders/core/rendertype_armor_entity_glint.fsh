#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec2 texCoord0;

out vec4 fragColor;

vec3 fire(float x)
{
	if (mod(x,10.0) > 5.0) x = x-6.0;
	float r = float(x <= 2.0) + float(x > 4.0) * 0.5;
	float g = max(1.0 - abs(x - 2.0) * 0.5, 0.0);
	float b = (1.0 - (x - 4.0) * 0.5) * float(x >= 4.0);
	return vec3(r,g,b);
}

vec3 smoothFire (float x)
{
    return mix(fire(floor(x*6.0)),fire(min(6.0,floor(x*6.0)+1.0)),fract(x*6.0));
}

void main() {
    vec4 color = texture(Sampler0, texCoord0) * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    float fade = linear_fog_fade(vertexDistance, FogStart, FogEnd);
    fragColor = vec4(smoothFire((color.r+color.g+color.b)/6)* fade, color.a);
}