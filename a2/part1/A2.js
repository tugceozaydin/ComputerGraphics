/*
 * UBC CPSC 314, Vjan2021
 * Assignment 2 Template
 */

// Setup and return the scene and related objects.
// You should look into js/setup.js to see what exactly is done here.
const {
  renderer,
  scene,
  camera,
  worldFrame,
} = setup();

/////////////////////////////////
//   YOUR WORK STARTS BELOW    //
/////////////////////////////////

// Initialize uniforms

// As in A1 we position the virus in the world solely using this uniform
// So the initial y-offset being 1.0 here is intended.
const virusOffset = { type: 'v3', value: new THREE.Vector3(0.0, 1.0, 0.0) };

// Pelvis frame is set with respect to the Armadillo.
const pelvisFrame = new THREE.Object3D();
// Position the pelvis in Aramdillo's object coordinate frame (note that the Armadillo is scaled).
pelvisFrame.position.copy(new THREE.Vector3(0.0, 20.0, 10.0));

// Dodge frame with respect to the Pelvis frame
const dodgeFrame = new THREE.Object3D();
pelvisFrame.add(dodgeFrame);
// Important: since we will manually update the dodge matrix,
// don't let the automatic scene graph traversal overwrite it.
dodgeFrame.matrixAutoUpdate = false;

// Distance threshold beyond which the armadillo should shoot lasers at the sphere (needed for Q1c).
const LaserDistance = 10.0;
// Minimum safe distance to virus (needed for Q1d).
const MinDistance = 6.0;
// Maximum hieght beyond which there is no point in dodging the virus (needed for Q1d).
const MaxHeight = 10.0;

let pelvisPos = pelvisFrame.localToWorld(pelvisFrame.position.clone());

// Materials: specifying uniforms and shaders
const armadilloMaterial = new THREE.ShaderMaterial({
  uniforms: {
    virusOffset: virusOffset,
    pelvisFrameMatrix: { value: pelvisFrame.matrix},
    dodgeFrameMatrix: {value: dodgeFrame.matrix},
    pelvisPosition: { value: pelvisPos },
    dodgePosition: { value: dodgeFrame.position },
      maxHeight: MaxHeight,
    // HINT: to add a Matrix4 uniform use the syntax:
    // <uniform name>: { value: <matrix4 variable name> },
    // You may need to add more than one.
    // HINT: Each frame has an associated transform accessibly via the `matrix` property.
  }
});

const sphereMaterial = new THREE.ShaderMaterial({
  uniforms: {
    virusOffset: virusOffset
  }
});

const eyeMaterial = new THREE.ShaderMaterial();

const leftLaserMaterial = new THREE.ShaderMaterial();
const rightLaserMaterial = new THREE.ShaderMaterial();
// HINT: Remember to add laser shaders if you decide to use a shader material for lasers.

// Load shaders.
const shaderFiles = [
  'glsl/armadillo.vs.glsl',
  'glsl/armadillo.fs.glsl',
  'glsl/sphere.vs.glsl',
  'glsl/sphere.fs.glsl',
  'glsl/eye.vs.glsl',
  'glsl/eye.fs.glsl',
];

new THREE.SourceLoader().load(shaderFiles, function (shaders) {
  armadilloMaterial.vertexShader = shaders['glsl/armadillo.vs.glsl'];
  armadilloMaterial.fragmentShader = shaders['glsl/armadillo.fs.glsl'];

  sphereMaterial.vertexShader = shaders['glsl/sphere.vs.glsl'];
  sphereMaterial.fragmentShader = shaders['glsl/sphere.fs.glsl'];

  eyeMaterial.vertexShader = shaders['glsl/eye.vs.glsl'];
  eyeMaterial.fragmentShader = shaders['glsl/eye.fs.glsl'];
});

// Load and place the Armadillo geometry.
loadAndPlaceOBJ('obj/armadillo.obj', armadilloMaterial, function (armadillo) {
  armadillo.rotation.y = Math.PI;
  armadillo.scale.set(0.1, 0.1, 0.1);
  armadillo.position.set(0.0, 5.3, -8.0)
  armadillo.add(pelvisFrame);
  scene.add(armadillo);
});

// Create the main covid sphere geometry
// https://threejs.org/docs/#api/en/geometries/SphereGeometry
const sphereGeometry = new THREE.SphereGeometry(1.0, 32.0, 32.0);
const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
scene.add(sphere);

const sphereLight = new THREE.PointLight(0xffffff, 1, 100);
scene.add(sphereLight);

// Eyes (Q1a and Q1b)
// Create the eye ball geometry
const eyeGeometry = new THREE.SphereGeometry(5, 32, 32);
// HINT: Replace the following with two eye ball meshes from the same geometry.
const leftEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
leftEye.position.set( 7, 50, -40 );
leftEye.lookAt(virusOffset.value);
dodgeFrame.add(leftEye);

const rightEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
rightEye.position.set( -7, 50, -40 ); // changing -40 to -50 makes laser move??
rightEye.lookAt(virusOffset.value);
dodgeFrame.add(rightEye);

// HINT: Use one of the lookAt funcitons available in three.js to make the eyes look at the virus.
// HINT: Remember to update these matrices every time the virus changes position.

// HINT: Add the eyes to the dodgeFrame to ensure they will follow the body when you implement Q1d.

// Lasers (Q1c)
// HINT: You can use THREE.CylinderGeometry to create lasers easily:
//       https://threejs.org/docs/index.html#api/en/geometries/CylinderGeometry
// NOTE: These could also be made with two camera facing trinagles or quads instead of a full blown
//       cylinder.
 const leftLaserGeometry = new THREE.CylinderGeometry( 1.0, 1.0, 1.0, 16 );
 const leftLaser = new THREE.Mesh( leftLaserGeometry, leftLaserMaterial );
 const rightLaserGeometry = new THREE.CylinderGeometry( 1.0, 1.0, 1.0, 16 );
 const rightLaser = new THREE.Mesh( rightLaserGeometry, rightLaserMaterial );

// HINT: To have lasers inherit the eye transforms, make them children of the eyeballs you created
// above.

// HINT: Remember that LaserDistance is given in world space units, but the actual scale of the
// lasers may be set in a different (possibly scaled) frame.

// HINT: As with eyes, remember that these need to be updated with every time the virus position
// changes.

// Dodge (Q1d)
// Make the armadillo dodge the virus by rotating the body away from the virus.

// HINT: Like with lasers, remember that MaxHeight and MinDistance is given in world space 
// units, but the actual transformation will happen in a different (possibly scaled) frame.

// Listen to keyboard events.
const keyboard = new THREEx.KeyboardState();
function checkKeyboard() {
  if (keyboard.pressed("W"))
    virusOffset.value.z -= 0.3;
  else if (keyboard.pressed("S"))
    virusOffset.value.z += 0.3;

  if (keyboard.pressed("A"))
    virusOffset.value.x -= 0.3;
  else if (keyboard.pressed("D"))
    virusOffset.value.x += 0.3;

  if (keyboard.pressed("E"))
    virusOffset.value.y -= 0.3;
  else if (keyboard.pressed("Q"))
    virusOffset.value.y += 0.3;


  let pelvisUp = { type: 'v3', value: pelvisFrame.up.clone()};
  pelvisUp.value.normalize();

  let virusPos2 = pelvisFrame.worldToLocal(virusOffset.value.clone());
  let pelvisToVirus = { type: 'v3', value: pelvisFrame.position.clone()};
  pelvisToVirus.value.sub(virusPos2);
  pelvisToVirus.value.normalize();

  let rotationAxis = new THREE.Vector3();
  rotationAxis.crossVectors(pelvisUp.value, pelvisToVirus.value);
  rotationAxis.normalize();
  let rotationAngle = 1 / pelvisUp.value.angleTo(pelvisToVirus.value);

  let dodgeInWorld = pelvisFrame.localToWorld(dodgeFrame.position.clone());
  if (Math.abs(virusOffset.value.x- dodgeInWorld.x) < MinDistance &&
      Math.abs(virusOffset.value.z - dodgeInWorld.z) < MinDistance &&
      Math.abs(virusOffset.value.y- dodgeInWorld.y) < MaxHeight &&
      (virusOffset.value.y > dodgeInWorld.y)) {
    dodgeFrame.matrix.makeRotationAxis(rotationAxis, rotationAngle);
  } else {
    dodgeFrame.matrix.identity();
  }


  let virus = dodgeFrame.worldToLocal(virusOffset.value.clone());
  let distance = leftEye.position.distanceTo(virus);
     if(distance / 10 < LaserDistance) {
        rightLaser.position.set(0, 0, distance / 2);
        rightLaser.scale.set(1.0, distance, 1.0);
        rightLaser.rotation.x = Math.PI / 2;
        rightEye.add(rightLaser);
        leftLaser.position.set(0, 0, distance / 2);
        leftLaser.scale.set(1.0, distance, 1.0);
        leftLaser.rotation.x = Math.PI / 2;
        leftEye.add(leftLaser);
     } else {
       rightEye.remove(rightLaser);
       leftEye.remove(leftLaser);
     }


  rightEye.lookAt(virusOffset.value);
  leftEye.lookAt(virusOffset.value);
  // HINT: You may need to place code or call functions here to make sure your tranforms are updated
  // whenever the virus position changes.

  // The following tells three.js that some uniforms might have changed.
  armadilloMaterial.needsUpdate = true;
  sphereMaterial.needsUpdate = true;
  eyeMaterial.needsUpdate = true;
  leftLaserMaterial.needsUpdate = true;
  rightLaserMaterial.needsUpdate = true;

  // Move the sphere light in the scene. This allows the floor to reflect the light as it moves.
  sphereLight.position.set(virusOffset.value.x, virusOffset.value.y, virusOffset.value.z);
}

// Setup update callback
function update() {
  checkKeyboard();

  // Requests the next update call, this creates a loop
  requestAnimationFrame(update);
  renderer.render(scene, camera);
}

// Start the animation loop.
update();
