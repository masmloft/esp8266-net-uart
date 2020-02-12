import qbs

Project {
    qbsSearchPaths: [
        "./Qbs",
    ]
    references: [
        "ESP8266Sdk.qbs",
        "ESP8266Core.qbs",
        "ESP8266WiFi.qbs",
    ]
}
