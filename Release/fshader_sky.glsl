#version 430

in  vec4 color;
in  vec2 texCoord;

out vec4 fColor;

uniform sampler2D texture;

void main() 
{ 
    fColor = texture2D( texture, texCoord );
} 
