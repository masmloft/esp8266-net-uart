import qbs

StaticLibrary {
    Depends { name: "ESP8266Core" }

    cpp.includePaths: [
        "esp8266-2.6.3/libraries/ESP8266WiFi/src",
    ]

    Export {
        Depends { name: "cpp" }
        Depends { name: "ESP8266Core" }
        cpp.includePaths: [
            "esp8266-2.6.3/libraries/ESP8266WiFi/src",
        ]
    }

    files: [
        "esp8266-2.6.3/libraries/ESP8266WiFi/src/**/*.h",
        "esp8266-2.6.3/libraries/ESP8266WiFi/src/**/*.c",
        "esp8266-2.6.3/libraries/ESP8266WiFi/src/**/*.cpp",
    ]
}
