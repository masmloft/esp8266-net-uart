#include <Arduino.h>
//#include <HardwareSerial.h>

const uint8_t LPIN = 2;

//HardwareSerial Serial(UART0);

void setup()
{
	pinMode(LPIN, OUTPUT);

}

void loop()
{
	digitalWrite(LPIN, LOW);
	delay(500);

	digitalWrite(LPIN, HIGH);
	delay(500);
}
