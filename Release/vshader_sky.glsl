#version 430

in  vec4 vPosition;
in  vec2 vTexCoord;

uniform mat4 model_view;
uniform mat4 projection;

out vec2 texCoord;

void main() 
{
	texCoord    = vTexCoord * 2;
	gl_Position = projection * model_view * (vPosition * 2);
}