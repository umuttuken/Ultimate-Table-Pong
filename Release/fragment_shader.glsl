#version 430 

in vec3 normal;
in vec3 lightDir;

in  vec4 color;
in	vec4 lightning;

uniform vec4 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;

uniform int mode;
uniform int shading_mode;

out vec4 fColor;

void main() 
{
	if(shading_mode == 1)
	{
		fColor = lightning * color ;
	
		if(mode == 0)
		{
			fColor = color;
		}
	}else if(shading_mode == 2)
	{
		float intensity;
		vec3 n;
		vec4 tempColor;
		n = normalize(normal);
		
		intensity = max(dot(lightDir, n),0.0);
		
		if(intensity > 0.98)
			fColor = color * vec4(0.8, 0.8, 0.8, 1.0);
		else if(intensity > 0.5)
			fColor = color * vec4(0.4, 0.4, 0.8, 1.0);
		else if(intensity > 0.25)
			fColor = color * vec4(0.2, 0.2, 0.4, 1.0);
		else
			fColor = color * vec4(0.1, 0.1, 0.1, 1.0);
			
		if(mode == 0)
		{
			fColor = color;
		}
	}
	
} 

