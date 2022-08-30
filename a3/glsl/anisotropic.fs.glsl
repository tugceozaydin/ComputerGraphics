// HINT: Don't forget to define the uniforms here after you pass them in in A3.js
uniform vec3 tangentDirection;

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
    // HINT: You may find it helpful to pre-compute some values here (e.g. normalized vectors)
    vec3 toLight = normalize(lightDirection);
    vec3 toV = normalize(-viewPosition);
    vec3 normal = normalize(interpolatedNormal);
    vec3 tangentDirection = normalize(tangentDirection);

    // compute new normal with the first two formula
    //T = D + (-D.N)*N
    vec3 T = normalize(tangentDirection + dot((-tangentDirection),normal)*normal);

    //P = L + (-L.T)*T
    vec3 P = normalize(toLight + dot((-toLight),T)*T);

    // B(l) = -L + 2(L.P)*P
    vec3 B = normalize(-toLight + 2.0*dot(toLight, P)*P);
    //float specular = pow(max(0.0, dot(B,toV)), shininess);
    float specular = pow(sqrt(1.0 - pow((dot(toLight,T)),2.0)) * sqrt(1.0-pow((dot(toV,T)),2.0)) - dot((toLight),T) * dot((toV),T), shininess);
    //float specular = pow(dot(toV, B),shininess);

    float diffuse = max(0.0, dot(P, toLight));
    //float diffuse = dot(toLight, P);

    // HINT: Compute the ambient component. Like in Phong, this component is uniform across surface.
    vec3 ambientComponent = ambientColor * kAmbient;

    // HINT: Compute the diffuse component, according to the Heidrich-Seidel model.
    // You may find this link helpful:
    // https://en.wikipedia.org/wiki/Specular_highlight#Heidrich%E2%80%93Seidel_anisotropic_distribution
    vec3 diffuseComponent = diffuse * diffuseColor * kDiffuse;

    // HINT: Compute the specular component. This will depend on the view direction.
    // you are allowed to use the optimized formula as well (see above link).
    //vec3 specularComponent =  vec3(v * kSpecular);
    vec3 specularComponent =  specular * specularColor * kSpecular;

    // HINT: Make sure that the light only affects vertices facing towards the light.

    // HINT: Set final rendered colour to be a combination of the three components
    //Hint: the clamp(<-N,L>) in the paper can be implemented with max(dot(N,L), 0.0) for our assignment.
    float clamp = max(dot(normal,toLight), 0.0);
    vec3 finalComponent = ambientComponent + clamp*(diffuseComponent + specularComponent);
    gl_FragColor = vec4(finalComponent, 1.0);
}
