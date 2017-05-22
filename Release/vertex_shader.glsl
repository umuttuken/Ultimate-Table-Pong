#version 430 
in  vec4 vPosition;
in  vec4 vColor;
in	vec4 vNormal;

uniform int mode;
uniform int shading_mode;

uniform mat4 model;
uniform mat4 view;

uniform mat4 model_view;
uniform mat4 projection;
uniform mat4 NormalMatrix;

uniform vec4 LightPosition;
uniform vec4 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;
uniform float Brightness;

uniform vec3 	theta;

out	vec4 color;
out	vec4 lightning;

out vec3 normal;
out vec3 lightDir;

void main() 
{
	vec3 pos = (vPosition).xyz;

	vec3 L = normalize(LightPosition.xyz - pos);
	vec3 V = normalize(-pos);
	vec3 H = normalize(L + V);
	vec3 N = (NormalMatrix * vNormal).xyz;
	
	if(mode == 2)
	{
		//vec4(5.0, -1.4, -3.7, 0.0));
		mat4 T_1   = mat4(1.0, 0.0, 0.0, 0.0,
						  0.0, 1.0, 0.0, 0.0,
						  0.0, 0.0, 1.0, 0.0,
					      -5, +1.4, +4.8, 1.0);

		mat4 T_2   = mat4(1.0, 0.0, 0.0, 0.0,
						  0.0, 1.0, 0.0, 0.0,
						  0.0, 0.0, 1.0, 0.0,
						  +5, -1.4, -4.8, 1.0);




		vec3 angles = radians( theta );
		vec3 c = cos( angles );
		vec3 s = sin( angles );

		mat4 rx = mat4( 1.0,  0.0,  0.0, 0.0,
						0.0,  c.x,  s.x, 0.0,
						0.0, -s.x,  c.x, 0.0,
						0.0,  0.0,  0.0, 1.0 );

		mat4 ry = mat4( c.y, 0.0, -s.y, 0.0,
						0.0, 1.0,  0.0, 0.0,
						s.y, 0.0,  c.y, 0.0,
						0.0, 0.0,  0.0, 1.0 );

		// Workaround for bug in ATI driver
		ry[1][0] = 0.0;
		ry[1][1] = 1.0;

		mat4 rz = mat4( c.z,  s.z, 0.0, 0.0,
					   -s.z,  c.z, 0.0, 0.0,
						0.0,  0.0, 1.0, 0.0,
						0.0,  0.0, 0.0, 1.0 );

		// Workaround for bug in ATI driver
		rz[2][2] = 1.0;

		N = (NormalMatrix * T_2 * rz * ry * rx * T_1 * vNormal).xyz;
	}

	vec4 ambient = AmbientProduct;
	
	float Kd = max( dot(L, N), 0.0 );
	vec4 diffuse = Kd * DiffuseProduct;
	
	float Ks = pow( max( dot(N, H), 0.0 ), Shininess );
	vec4 specular = Ks * SpecularProduct;
	
	if( dot(L, N) < 0.0 )
		specular = vec4(0.0, 0.0, 0.0, 1.0);
		
	if(shading_mode == 2)
	{
		lightDir = normalize(LightPosition.xyz);
		normal = normalize((NormalMatrix*vNormal).xyz);
	}	

	// SQUARES + TEXT
	if(mode == 0)
	{
		gl_Position = (vPosition/vPosition.w);
		color = vColor;
	}
	// OBJECTS
	else if(mode == 1)
	{
		gl_Position = projection * model_view * (vPosition/vPosition.w);
		if(shading_mode == 1)
		{
			color = vColor * Brightness;
		}
		else if(shading_mode == 2)
		{
			color = vColor;
		}
	}
	// ROTATING
	else if( mode == 2)
	{
		//vec4(5.0, -1.4, -3.8, 0.0));
		mat4 T_1   = mat4(1.0, 0.0, 0.0, 0.0,
						  0.0, 1.0, 0.0, 0.0,
						  0.0, 0.0, 1.0, 0.0,
					      -5, +1.4, +4, 1.0);

	
		mat4 T_2   = mat4(1.0, 0.0, 0.0, 0.0,
						  0.0, 1.0, 0.0, 0.0,
						  0.0, 0.0, 1.0, 0.0,
						  +5, -1.4, -4, 1.0);




		vec3 angles = radians( theta );
		vec3 c = cos( angles );
		vec3 s = sin( angles );

		mat4 rx = mat4( 1.0,  0.0,  0.0, 0.0,
						0.0,  c.x,  s.x, 0.0,
						0.0, -s.x,  c.x, 0.0,
						0.0,  0.0,  0.0, 1.0 );

		mat4 ry = mat4( c.y, 0.0, -s.y, 0.0,
						0.0, 1.0,  0.0, 0.0,
						s.y, 0.0,  c.y, 0.0,
						0.0, 0.0,  0.0, 1.0 );

		// Workaround for bug in ATI driver
		ry[1][0] = 0.0;
		ry[1][1] = 1.0;

		mat4 rz = mat4( c.z,  s.z, 0.0, 0.0,
					   -s.z,  c.z, 0.0, 0.0,
						0.0,  0.0, 1.0, 0.0,
						0.0,  0.0, 0.0, 1.0 );

		// Workaround for bug in ATI driver
		rz[2][2] = 1.0;

		mat4 allTrans = T_2 * rz * ry * rx * T_1;
		
		gl_Position = projection * model_view * T_2 * rz * ry * rx * T_1 *(vPosition/vPosition.w);

		if(shading_mode == 1)
		{
			color = vColor * Brightness;
		}
		else if(shading_mode == 2)
		{
			color = vColor;
		}
	}

	vec4 lightcolor = ambient + diffuse + specular;
	lightcolor.a = 1.0;
	
	lightning = lightcolor;	
}