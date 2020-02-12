import qbs

CppApplication {
    type: ["application", "sizeinfo"]

    Depends { name: "cpp" }
    Depends { name: "ESP8266Core" }

    ESP8266Module.serialPort: "COM27"

    files: [
        "**/*.h",
        "**/*.c",
        "**/*.cpp",
    ]
}

