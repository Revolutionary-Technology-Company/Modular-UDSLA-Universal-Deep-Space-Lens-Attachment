/* * NAVYSCOPE LX200 EMULATOR SNIPPET
 * Paste this into your existing parseCommand() function.
 * This tricks Stellarium into thinking it is talking to a real LX200.
 */

void parseCommand(String command) {
  
  // --- EXISTING FOCUS COMMANDS ---
  if (command.indexOf("F+") >= 0) {
    focusMotor.move(FOCUS_INCREMENT); 
  }
  else if (command.indexOf("F-") >= 0) {
    focusMotor.move(-FOCUS_INCREMENT); 
  }

  // --- NEW: STELLARIUM HANDSHAKES (LX200 Protocol) ---
  
  // Command: :GR#  (Get RA - "Where are you pointing?")
  // We reply with a dummy coordinate (or real encoder data if you have it)
  // Format: HH:MM:SS#
  if (command.indexOf(":GR#") >= 0) {
    Serial.print("12:00:00#"); 
  }

  // Command: :GD# (Get Declination)
  // Format: sDD*MM# (s=sign)
  else if (command.indexOf(":GD#") >= 0) {
    Serial.print("+45*00#"); 
  }

  // Command: :CM# (Sync/Calibrate)
  // Stellarium says "You are here." We say "Okay."
  else if (command.indexOf(":CM") >= 0) {
    Serial.print("M31 EXCALIBUR#"); // Any text ending in # usually works
  }
}
