// HINT: Don't forget to define the uniforms here after you pass them in in A3.js

// The value of our shared variable is given as the interpolation between normals computed in the vertex shader
// below we can see the shared variable we passed from the vertex shader using the 'in' classifier
in vec3 interpolatedNormal;
in vec3 lightDirection;
in vec3 viewPosition;
in vec4 viewNormal;
in vec3 viewDirection;
in float fresnel;

uniform vec3 lightColor;
uniform vec3 toonColor;
uniform vec3 toonColor2;
uniform vec3 outlineColor;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

void main() {
// intensity v.l
// n.v = 0 silhouette edges
    // HINT: Compute the light intensity the current fragment by determining
    // the cosine angle between the surface normal and the light vector
    vec3 normal = normalize(interpolatedNormal);
    vec3 toLight = normalize(lightDirection);
    vec3 toV = normalize(-viewPosition);

    float lightIntensity = max(dot(toLight,normal), 0.0);
    vec4 finalColor;

    if ((lightIntensity) >= 0.7)
    		finalColor = vec4(toonColor, 1.0);
    else if ((lightIntensity) > 0.5)
            finalColor = vec4(toonColor * 0.5 + toonColor2 * (1.0 - 0.5), 1.0);
    else if ((lightIntensity) > 0.3)
            finalColor = vec4(toonColor * 0.3 + toonColor2 * (1.0 - 0.3), 1.0);
    else if ((lightIntensity) <= 0.3)
            finalColor = vec4(toonColor2, 1.0);

    // HINT: Define ranges of light intensity values to shade. GLSL has a
    // built-in `ceil` function that you could use to determine the nearest
    // light intensity range.

    // HINT: You should use two tones of colors here; `toonColor` is a yellow
    // color for brighter areas and `toonColor2` is a red color for darker areas.
    // Use the light intensity to blend the two colors.

    // HINT: To achieve the toon silhouette outline, set a dark fragment color
    // if the current fragment is located near the edge of the 3D model.
    // Use a reasonable value as the threshold for the silhouette thickness
    // (i.e. proximity to edge).
    	if (fresnel < 0.4)
    		finalColor = vec4(outlineColor, 1.0);

    // HINT: Set final rendered colour
    gl_FragColor = finalColor;
}
