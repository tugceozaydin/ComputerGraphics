// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 virusPosition;

void main() {


    // Multiply each vertex by the model matrix to get the world position of each vertex, 
    // then the view matrix to get the position in the camera coordinate system, 
    // and finally the projection matrix to get final vertex position.
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(virusPosition + position, 1.0);

}
