#version 150

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;

in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord2;
in vec4 normal;

out vec4 fragColor;

vec3 rainbow(float x)
{
	if (mod(x,10.0) > 5.0)
        	x = x-6.0;
	float r = float(x <= 2.0) + float(x > 4.0) * 0.5;
	float g = max(1.0 - abs(x - 2.0) * 0.5, 0.0);
	float b = (1.0 - (x - 4.0) * 0.5) * float(x >= 4.0);
	return vec3(r,g,b);
}

vec3 smoothRainbow (float x)
{
    return mix(rainbow(floor(x*6.0)),rainbow(min(6.0,floor(x*6.0)+1.0)),fract(x*6.0));
}

void main() {
    vec3 color = smoothRainbow(texCoord0.x);
    fragColor = vec4(color,0.3);
}
