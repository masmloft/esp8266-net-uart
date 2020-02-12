#include <Arduino.h>
#include <HardwareSerial.h>
#include <ESP8266WiFi.h>

const uint8_t LPIN = 2;

HardwareSerial Serial(UART0);

WiFiServer server(23);


void setup()
{
	pinMode(LPIN, OUTPUT);

	Serial.begin(115200);

	WiFi.persistent(false);

	delay(100);

	server.begin(23);

}

void blinkLed()
{
	static bool ledState = false;
	digitalWrite(LPIN, ledState);
	ledState = !ledState;
	digitalWrite(LPIN, ledState);
}

bool initWifi()
{
	while (WiFi.status() == WL_CONNECTED)
		return true;

	//bool wifi_ap = true;
	bool wifi_ap = false;
	if(wifi_ap == true)
	{
		//		WiFi.setSleepMode(WIFI_MODEM_SLEEP);
		WiFi.setPhyMode(WIFI_PHY_MODE_11B);
		Serial.print("Setting soft-AP ... ");
		boolean result = WiFi.softAP("MW", "wsadwsad", 1, 1, 3);
		if(result == true)
			Serial.println("Ready");
		else
			Serial.println("Failed!");
	}
	else
	{
		//String wc_ssid = "QW_SML_WLAN";
		//String wc_password = "WirelessSml";
		//IPAddress wc_ip(192,168,1,35);

		//String wc_ssid = "sn-600";
		String wc_ssid = "Prog";
		String wc_password = "skynetltd";
		//IPAddress wc_ip(192,168,9,35);

		IPAddress wc_gateway(0,0,0,0);
		IPAddress wc_subnet(255,255,255,0);
		//		String wc_ssid = "QW_SML_WLAN";
		//		String wc_password = "WirelessSml";

		WiFi.begin(wc_ssid.c_str(), wc_password.c_str());
		//		WiFi.config(wc_ip, wc_gateway, wc_subnet);
		while (WiFi.status() != WL_CONNECTED)
		{
			delay(1000);
			Serial.print(".");
			blinkLed();
		}

		Serial.println("");
		Serial.print("Connected to ");
		Serial.println(wc_ssid.c_str());
		Serial.print("IP address: ");
		Serial.println(WiFi.localIP());
	}

	return true;
}

void loop()
{
	{
		bool res = initWifi();
		if(res == false)
		{
			return;
		}
	}

	WiFiClient client = server.available();
	if(!client)
	{
		digitalWrite(LPIN, LOW);
		return;
	}

	{
		while (client.connected())
		{
			static unsigned long prevMs = millis();
			unsigned long currMs = millis();
			if(abs(currMs - prevMs) > 500)
			{
				prevMs = currMs;
//				blinkLed();
			}

			if (Serial.available())
			{
				int res = Serial.read();
				if(res != -1)
				{
					blinkLed();
					client.write(res);
				}
			}

			while (client.available() > 0)
			{
				blinkLed();
				char c = client.read();
				Serial.write(c);
			}
		}
	}
}
