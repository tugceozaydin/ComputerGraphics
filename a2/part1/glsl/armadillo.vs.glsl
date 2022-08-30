// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 virusOffset;
uniform mat4 pelvisFrameMatrix;
uniform mat4 dodgeFrameMatrix;
uniform vec3 pelvisPosition;
uniform vec3 dodgePosition;
uniform float maxHeight;

// The shared variable is initialized in the vertex shader and attached to the current vertex being processed,
// such that each vertex is given a shared variable and when passed to the fragment shader,
// these values are interpolated between vertices and across fragments,
// below we can see the shared variable is initialized in the vertex shader using the 'out' qualifier
out vec3 colour;

void main() {

float weight;
vec3 oldPosition = position;
    // Vertex position in world coordinates.
    // HINT: You will need to change worldPos to make the Armadillo dodge the virus.
    // HINT: Q1e should be done entirely in this shader.
    vec4 worldPos;

    if(position.y > pelvisPosition.y){
        mat4 inversePelvis = inverse(pelvisFrameMatrix);
        worldPos  = modelMatrix * pelvisFrameMatrix * dodgeFrameMatrix * inversePelvis * vec4(position, 1.0);
    } else {
        worldPos = modelMatrix * vec4(position, 1.0);
    }


// Following is for Q1.e
    //if (position.y <= pelvisPosition.y) {
    //    weight = 0.0;
   // }
    //else if (position.y >= maxHeight) {
   //     weight = 1.0;
    //}
   // else {
   //     weight = (pelvisPosition.y - position.y)/(maxHeight - pelvisPosition.y);
   // }

    // both in worldFrame
    //vec4 oldPosInWorldFrame = modelMatrix * vec4(oldPosition, 1.0);
    //vec4 newPosInWorldFrame = modelMatrix * vec4(position, 1.0);

    //worldPos =  oldPosInWorldFrame * weight + newPosInWorldFrame * (1.0 - weight);

    // This should really be transformed by the pelvis transform if on the upper body
    // vertex normal in camera frame, but we won't worry about correct shading for this assignment.
    vec3 vertexNormal = normalize(normalMatrix*normal);

    // Set light direction, in camera frame.
    vec3 lightDirection = normalize(vec3(viewMatrix*(vec4(virusOffset - worldPos.xyz, 0.0))));

    float vertexColour = dot(lightDirection, vertexNormal);
    colour = vec3(vertexColour);

    // Multiply each vertex by the model matrix to get the world position of each vertex, 
    // then the view matrix to get the position in the camera coordinate system, 
    // and finally the projection matrix to get final vertex position
    gl_Position = projectionMatrix * viewMatrix * worldPos;
    
}
