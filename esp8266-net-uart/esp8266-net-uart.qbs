import qbs

CppApplication {
    type: ["application", "sizeinfo"]

    Depends { name: "cpp" }
    Depends { name: "ESP8266Core" }
    Depends { name: "ESP8266WiFi" }

    ESP8266Module.serialPort: "COM27"

    files: [
        "**/*.h",
        "**/*.c",
        "**/*.cpp",
        "**/*.S",
    ]
}

