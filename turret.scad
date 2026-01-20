#include <AccelStepper.h>

// --- PIN DEFINITIONS ---
// BASE (Azimuth)
#define AZ_STEP_PIN 5
#define AZ_DIR_PIN 6
// TILT (Altitude)
#define ALT_STEP_PIN 7
#define ALT_DIR_PIN 8

// --- MOTOR SETUP ---
AccelStepper azMotor(AccelStepper::DRIVER, AZ_STEP_PIN, AZ_DIR_PIN);
AccelStepper altMotor(AccelStepper::DRIVER, ALT_STEP_PIN, ALT_DIR_PIN);

// SPEEDS
const float SLEW_SPEED = 2000.0; // Fast for moving to target
const float TRACK_SPEED = 15.0;  // Slow to follow stars

void setup() {
  Serial.begin(9600);
  
  // Settings for Heavy Turret Base
  azMotor.setMaxSpeed(3000);
  azMotor.setAcceleration(1000); // Smooth start/stop (No Jerk)
  
  altMotor.setMaxSpeed(3000);
  altMotor.setAcceleration(1000);
}

void loop() {
  azMotor.run();
  altMotor.run();
  
  // (Existing Serial Event logic goes here)
}

// --- UPDATED COMMAND PARSER ---
void parseCommand(String command) {
  
  // 1. FOCUS (Existing)
  if (command.indexOf("F+") >= 0) { /* Focus Move Code */ }

  // 2. MOVE NORTH (Tilt Up)
  // Stellarium Command: :Mn#
  if (command.indexOf(":Mn#") >= 0) {
    altMotor.setSpeed(SLEW_SPEED); 
    // We don't use 'move()' here because we want it to run UNTIL we say stop
  }

  // 3. MOVE SOUTH (Tilt Down)
  // Stellarium Command: :Ms#
  if (command.indexOf(":Ms#") >= 0) {
    altMotor.setSpeed(-SLEW_SPEED);
  }

  // 4. MOVE EAST (Rotate Base Right)
  // Stellarium Command: :Me#
  if (command.indexOf(":Me#") >= 0) {
    azMotor.setSpeed(SLEW_SPEED);
  }

  // 5. STOP MOVEMENT
  // Stellarium Command: :Q# (Quit moving)
  if (command.indexOf(":Q#") >= 0) {
    azMotor.setSpeed(0);
    altMotor.setSpeed(0);
    // Optional: Switch to "Tracking Speed" here to follow the earth's rotation
  }
}
