import qbs

StaticLibrary {
    Depends { name: "cpp" }
    Depends { name: "ESP8266Module" }
    Depends { name: "ESP8266Sdk" }

    cpp.includePaths: [
        "esp8266-2.6.3/cores/esp8266",
        "esp8266-2.6.3/variants/nodemcu",
    ]

    Export {
        Depends { name: "cpp" }
        Depends { name: "ESP8266Module" }
        Depends { name: "ESP8266Sdk" }

        cpp.includePaths: [
            "esp8266-2.6.3/cores/esp8266",
            "esp8266-2.6.3/variants/nodemcu",
        ]
    }

    files: [
        "esp8266-2.6.3/cores/esp8266/**/*.h",
        "esp8266-2.6.3/cores/esp8266/*.h",
        "esp8266-2.6.3/cores/esp8266/*.c",
        "esp8266-2.6.3/cores/esp8266/*.cpp",
        "esp8266-2.6.3/cores/esp8266/*.s",
        "esp8266-2.6.3/cores/esp8266/libb64/*.h",
        "esp8266-2.6.3/cores/esp8266/libb64/*.c",
        "esp8266-2.6.3/cores/esp8266/libb64/*.cpp",
        "esp8266-2.6.3/cores/esp8266/spiffs/*.h",
        "esp8266-2.6.3/cores/esp8266/spiffs/*.c",
        "esp8266-2.6.3/cores/esp8266/spiffs/*.cpp",
        "esp8266-2.6.3/cores/esp8266/umm_malloc/*.h",
        "esp8266-2.6.3/cores/esp8266/umm_malloc/*.c",
        "esp8266-2.6.3/cores/esp8266/umm_malloc/*.cpp",
    ]
}
