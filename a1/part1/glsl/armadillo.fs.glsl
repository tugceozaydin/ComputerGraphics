// The value of our shared variable is given as the interpolation between normals computed in the vertex shader
// below we can see the shared variable we passed from the vertex shader using the 'in' classifier
in vec3 interpolatedNormal;
in vec3 lightVector;
in vec3 newNormal;

void main() {
	
	// The direction of the light (normalized) is important for calculating shading that results from light hitting an object

  	// HINT: GLSL PROVIDES THE DOT() FUNCTION 
  	// HINT: SHADING IS CALCULATED BY TAKING THE DOT PRODUCT OF THE NORMAL AND LIGHT DIRECTION VECTORS
    float cosine = dot(interpolatedNormal, normalize(lightVector));

    vec3 color;
        if(length(lightVector) < 3.0){
            color = vec3(0.0, 1.0, 0.0); // green
           } else {
            color = vec3(1.0, 1.0, 1.0); // white
           }
       gl_FragColor = vec4(color * cosine, 1.0);
}
