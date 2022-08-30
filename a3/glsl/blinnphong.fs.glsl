// HINT: Don't forget to define the uniforms here after you pass them in in A3.js

// The value of our shared variable is given as the interpolation between normals computed in the vertex shader
// below we can see the shared variable we passed from the vertex shader using the 'in' classifier
in vec3 interpolatedNormal;
in vec3 lightDirection;
in vec3 viewPosition;

uniform vec3 ambientColor;
uniform vec3 lightColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

void main() {

    vec3 toLight = normalize(lightDirection);
    vec3 toV = normalize(-viewPosition);
    vec3 h = normalize(toV + toLight);
    vec3 normal = normalize(interpolatedNormal);

    float specular = pow(max(0.0, dot(h,normal)), shininess);
    float diffuse = max(0.0, dot(normal, toLight));

    // HINT: Compute the ambient component as you did in the Phong shader.
    vec3 ambientComponent = ambientColor * kAmbient;

    // HINT: Compute the diffuse component as you did in the Phong shader.
    vec3 diffuseComponent = diffuse * diffuseColor * kDiffuse;

    // HINT: Compute the specular component. Recall from the specs that the
    // difference between the specular terms in the Phong and Blinn-Phong models
    // Difference is using h.n instead of B.v
    vec3 specularComponent =  specular * specularColor * kSpecular;

    // HINT: Set final rendered colour to be a combination of the three components
    vec3 finalComponent = ambientComponent + diffuseComponent + specularComponent;
    gl_FragColor = vec4(finalComponent, 1.0);
}
