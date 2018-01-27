#include <Servo.h>

char sCmd; // Data received from the serial port

int Valve1pin       = 10;
int Valve2pin       = 11;
int Valve3pin       = 12;

int LED1pin         = 7;
int LED2pin         = 8;
int LED3pin         = 9;

int TriggerPin      = 13; // 

Servo Valve1Servo;
Servo Valve2Servo;
Servo Valve3Servo;

int Valve1Pos1 = 0; // up (inflow OFF)
int Valve1Pos2 = 90; // sideways (ON)
int Valve1Pos3 = 180; // down (outflow OFF)

int Valve2Pos1 = 20; 
int Valve2Pos2 = 105;
int Valve2Pos3 = 180;

int Valve3Pos1 = 0;
int Valve3Pos2 = 90;
int Valve3Pos3 = 180;


int Valve1Angle = Valve1Pos1;
int Valve2Angle = Valve2Pos1;
int Valve3Angle = Valve3Pos1;



int trigger_ms = 10;

/////////////////////////////////

void setup(){

  Valve1Servo.attach(Valve1pin);
  Valve1Servo.write(Valve1Angle);
  Valve2Servo.attach(Valve2pin);
  Valve2Servo.write(Valve2Angle);
  Valve3Servo.attach(Valve3pin);
  Valve3Servo.write(Valve3Angle);

  pinMode(LED1pin, OUTPUT); // Set pin as OUTPUT
  pinMode(LED2pin, OUTPUT); // Set pin as OUTPUT
  pinMode(LED3pin, OUTPUT); // Set pin as OUTPUT
  
  pinMode(TriggerPin, OUTPUT); // Set pin as OUTPUT
  Serial.begin(9600); // Start serial communication at 9600 bps

  Serial.println("Open DrugMaster v0.01");
  Serial.println("To open valves, press 1, 2, 3...");  
  Serial.println("To close valves, press q, w, e...");

}

void loop(){

  digitalWrite(TriggerPin, LOW); // trigger low
  if(Serial.available()) {
    sCmd = Serial.read();
    switch (sCmd) {

     case '1':  // Open Valve 1
        Serial.print("Opening valve 1...");
        Valve1Angle = Valve1Pos2;
        Valve1Servo.write(Valve1Angle);
        digitalWrite(LED1pin, HIGH);       // LED
        digitalWrite(TriggerPin, HIGH);       // Trigger
        delay(trigger_ms);
        digitalWrite(TriggerPin, LOW);  
        Serial.println("done!");
        break;
       
     case 'q':  // Close Valve 1
        Serial.print("Closing valve 1...");
        Valve1Angle = Valve1Pos1;
        Valve1Servo.write(Valve1Angle);
        digitalWrite(LED1pin, LOW);       // LED
        digitalWrite(TriggerPin, HIGH);       // Trigger
        delay(trigger_ms);
        digitalWrite(TriggerPin, LOW);  
        Serial.println("done!");
        break;
             


         case '2':  // Open Valve 2
        Serial.print("Opening valve 2...");
        Valve2Angle = Valve2Pos2;
        Valve2Servo.write(Valve2Angle);
        digitalWrite(LED2pin, HIGH);       // LED
        digitalWrite(TriggerPin, HIGH);       // Trigger
        delay(trigger_ms);
        digitalWrite(TriggerPin, LOW);  
       Serial.println("done!");
        break;
   
     case 'w':  // Close Valve 2
        Serial.print("Closing valve 2...");
        Valve2Angle = Valve2Pos1;
        Valve2Servo.write(Valve2Angle);
        digitalWrite(LED2pin, LOW);       // LED
        digitalWrite(TriggerPin, HIGH);       // Trigger
        delay(trigger_ms);
        digitalWrite(TriggerPin, LOW);  
        Serial.println("done!");
        break;

        case '3':  // Open Valve 3
        Serial.print("Opening valve 3...");
        Valve3Angle = Valve3Pos2;
        Valve3Servo.write(Valve3Angle);
        digitalWrite(LED3pin, HIGH);       // LED
        digitalWrite(TriggerPin, HIGH);       // Trigger
        delay(trigger_ms);
        digitalWrite(TriggerPin, LOW);  
       Serial.println("done!");
        break;

     case 'e':  // Close Valve 3
        Serial.print("Closing valve 3...");
        Valve3Angle = Valve3Pos1;
        Valve3Servo.write(Valve3Angle);
        digitalWrite(LED3pin, LOW);       // LED
        digitalWrite(TriggerPin, HIGH);       // Trigger
        delay(trigger_ms);
        digitalWrite(TriggerPin, LOW);  
       Serial.println("done!");
        break;
    }
  }

  delay(1000); 

//  Valve1Angle+=90;
//  if (Valve1Angle>180){Valve1Angle=0;}
//  Valve1Servo.write(Valve1Angle);
  
  
}















