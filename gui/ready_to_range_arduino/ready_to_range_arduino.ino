/**
  The pozyx ready to range demo (c) Pozyx Labs
  please check out https://www.pozyx.io/Documentation/Tutorials/getting_started

  This demo requires two pozyx devices and one Arduino. It demonstrates the ranging capabilities and the functionality to
  to remotely control a pozyx device. Place one of the pozyx shields on the Arduino and upload this sketch. Move around
  with the other pozyx device.

  This demoe measures the range between the two devices. The closer the devices are to each other, the more LEDs will
  burn on both devices.
*/

#include <Pozyx.h>
#include <Pozyx_definitions.h>
#include <Wire.h>

////////////////////////////////////////////////
////////////////// PARAMETERS //////////////////
////////////////////////////////////////////////

uint16_t destination_id = 0x665B;     // the network id of the other pozyx device: fill in the network id of the other device
signed int range_step_mm = 1000;      // every 1000mm in range, one LED less will be giving light.
int uwb_channel = 1;                  // set the channel
int ite = 1;
boolean syn;



////////////////////////////////////////////////

void setup() {
  Serial.begin(115200);

  if (Pozyx.begin() == POZYX_FAILURE) {
    Serial.println("ERROR: Unable to connect to POZYX shield");
    Serial.println("Reset required");
    //Pozyx.setUWBChannel(uwb_channel); // setting the UWB channel
    //Pozyx.setUWBChannel(uwb_channel, destination_id); // setting the UWB channel destination

    delay(100);
    abort();
  }



  /*
    Serial.println("------------POZYX RANGING V1.0------------");
    Serial.println("NOTES:");
    Serial.println("- Change the parameters:\n\tdestination_id (target device)\n\trange_step (mm)\n\t");
    Serial.println();
    Serial.println("- Approach target device to see range and\n led control");
    Serial.println("------------POZYX RANGING V1.0------------");
    Serial.println("");
  */
  uint16_t nSamples;

  // Used to syn with Matlab. Up to here, just measurements

  Serial.println("READY");


  // make sure the pozyx system has no control over the LEDs, we're the boss
  uint8_t configuration_leds = 0x0;
  Pozyx.regWrite(POZYX_CONFIG_LEDS, &configuration_leds, 1);

  // do the same with the remote device
  Pozyx.remoteRegWrite(destination_id, POZYX_CONFIG_LEDS, &configuration_leds, 1);



  // Not syn
  syn = false;
}

void loop() {
  // if there is data to read
  /*
    if (Serial.available() > 0 && syn == false) {
    nSamples = Serial.read(); // read data
    }
  */


  /*
    if (Serial.available() > 0) {
      delay(300);
      int a = Serial.read();
      delay(300);
      int b = Serial.read();
      delay(300);
      int c = Serial.read();
      delay(300);
      int d = Serial.read();
      delay(300);
      Serial.println(a);
      Serial.println(a, HEX);
      Serial.println(b);
      Serial.println(b, HEX);
      Serial.println(c);
      Serial.println(c, HEX);
      Serial.println(d);
      Serial.println(d, HEX);
      destination_id = (a<<24) | (b<<16)| (c<<8) | d;
      Serial.println(destination_id);
      Serial.println(destination_id, HEX);

    }
  */

  /*
    Pozyx.setUWBChannel(uwb_channel, destination_id); // setting the UWB channel destination
    Pozyx.setUWBChannel(uwb_channel); // setting the UWB channel
  */

  // Wait a bit an syn first lecture

  if (ite == 1 && syn == false) {
    // delay(1000);
    syn = true;
  }



  /* More than one variable

    if (Serial.available())  {
      char c = Serial.read();  //gets one byte from serial buffer
      if (c == ',') {
        Serial.println(readString); //prints string to serial port out
        //do stuff with the captured readString
        if(readString.indexOf("on") >=0)
        {
          digitalWrite(ledPin, HIGH);
          Serial.println("LED ON");
        }
        if(readString.indexOf("off") >=0)
        {
          digitalWrite(ledPin, LOW);
          Serial.println("LED OFF");
        }
        readString=""; //clears variable for new input
      }
      else {
        readString += c; //makes the string readString
      }
    }
  */

  int status = 1;
  device_range_t range;
  status &= Pozyx.doRanging(destination_id, &range);


  //
  if (status == POZYX_SUCCESS && syn == true) {
    // let's do ranging with the destination

    Serial.println(ite);
    // Serial.print("sample \t");
    Serial.println(range.timestamp);
    // Serial.print("ms \t");
    Serial.println(range.distance);
    // Serial.print("mm \t");

    //times[ite] = int(range.timestamp);
    // distances[ite] = int(range.distance);
    // Serial.println(times[ite]);
    //Serial.print(ite);
    //Serial.println(" Sample  \t");
    ite++;
  }


  // now control some LEDs; the closer the two devices are, the more LEDs will be lit
  if (ledControl(range.distance) == POZYX_FAILURE) {
    //Serial.println("ERROR: setting (remote) leds");
  }

  else {
    // Serial.println("ERROR: ranging");
  }

}

int ledControl(uint32_t range) {
  int status = 1;

  // set the LEDs of this pozyx device
  status &= Pozyx.setLed(4, (range < range_step_mm));
  status &= Pozyx.setLed(3, (range < 2 * range_step_mm));
  status &= Pozyx.setLed(2, (range < 3 * range_step_mm));
  status &= Pozyx.setLed(1, (range < 4 * range_step_mm));

  // set the LEDs of the remote pozyx device
  status &= Pozyx.setLed(4, (range < range_step_mm), destination_id);
  status &= Pozyx.setLed(3, (range < 2 * range_step_mm), destination_id);
  status &= Pozyx.setLed(2, (range < 3 * range_step_mm), destination_id);
  status &= Pozyx.setLed(1, (range < 4 * range_step_mm), destination_id);

  // status will be zero if setting the LEDs failed somewhere along the way
  return status;
}
