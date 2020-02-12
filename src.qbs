import qbs

Project {
    qbsSearchPaths: [
        "./Esp8266Libs/Qbs",
    ]

    references: [
        "Esp8266Libs/Esp8266Libs.qbs",

        "blink2/blink2.qbs",
        "esp8266-net-uart/esp8266-net-uart.qbs",
    ]
}
