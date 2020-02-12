import qbs

Product {
    Export {
        Depends { name: "cpp" }

        cpp.defines: [
            "ICACHE_FLASH",
            "LWIP_OPEN_SRC",
            "TCP_MSS=536",
            "LWIP_FEATURES=1",
            "LWIP_IPV6=0",

        ]
        cpp.includePaths: [
            "esp8266-2.6.3/tools/sdk/include",
            "esp8266-2.6.3/tools/sdk/lwip2/include",
            "esp8266-2.6.3/tools/sdk/libc/xtensa-lx106-elf/include",
        ]
        cpp.linkerFlags: [
            "-Teagle.flash.4m.ld",
        ]
        cpp.libraryPaths: [
            "esp8266-2.6.3/tools/sdk/lib",
            "esp8266-2.6.3/tools/sdk/lib/NONOSDK22x_190703",
            "esp8266-2.6.3/tools/sdk/ld",
            "esp8266-2.6.3/tools/sdk/libc/xtensa-lx106-elf/lib"
        ]
        cpp.staticLibraries: [
            "hal",
            "phy",
            "pp",
            "net80211",
            "lwip2-536-feat",
            "wpa",
            "crypto",
            "main",
            "wps",
            "bearssl",
            "axtls",
            "espnow",
            "smartconfig",
            "airkiss",
            "wpa2",
            "stdc++",
            "m",
            "c",
            "gcc",
        ]

    }

    files: [
        "esp8266-2.6.3/tools/sdk/**/*.h",
        "esp8266-2.6.3/tools/sdk/**/*.a",
        "esp8266-2.6.3/tools/sdk/**/*.ld",
    ]

}
