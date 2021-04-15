#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform mat4 ProjMat;
uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in vec4 vertexColor;
in vec2 texCoord0;

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
    vec4 color = vec4(smoothRainbow(texCoord0.x),0.3);
    color *= vertexColor * ColorModulator;
    float fragmentDistance = -ProjMat[3].z / ((gl_FragCoord.z) * -2.0 + 1.0 - ProjMat[2].z);
    fragColor = linear_fog(color, fragmentDistance, FogStart, FogEnd, FogColor);
}
