// HINT: Don't forget to define the uniforms here after you pass them in in A3.js
uniform vec3 lightColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;
uniform float ticks;

// The value of our shared variable is given as the interpolation between normals computed in the vertex shader
// below we can see the shared variable we passed from the vertex shader using the 'in' classifier
in vec3 interpolatedNormal;
in vec3 lightDirection;
in vec3 vertexPosition;

void main() {
    // HINT: Compute the light intensity the current fragment by determining
    // the cosine angle between the surface normal and the light vector.
    vec3 normal = normalize(interpolatedNormal);
    vec3 toLight = normalize(lightDirection);

    float lightIntensity = max(dot(toLight,normal), 0.0);

    // HINT: Pick any two colors and blend them based on light intensity
    // to give the 3D model some color and depth.
    vec3 color1 = vec3(1.0, 0.0, 1.0);
    vec3 color2 = vec3(0.0, 1.0, 1.0);
    vec4 finalColor;

    // HINT: Render (or not) the current fragment based on its vertical position
    // to get the stripe effect. Think of a way to use a time component to "roll"
    // these stripes down the model over time.

    if ((lightIntensity) >= 0.7)
        finalColor = vec4(color1, 1.0);
    //blend mid colors
    else if ((lightIntensity) > 0.3)
        finalColor = vec4(color1 * lightIntensity + color2 * (1.0 - lightIntensity), 1.0);
    else if ((lightIntensity) <= 0.3)
        finalColor = vec4(color2, 1.0);

    if (sin(vertexPosition.y +ticks) < 0.0) {
    	discard;
    }
    // HINT: `discard` throws away (does not render) the current fragment.

    // HINT: Set final rendered colour
    gl_FragColor = finalColor;
}
