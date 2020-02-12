import qbs
import qbs.FileInfo
import qbs.Utilities
import qbs.TextFile
import qbs.Process

Module  {
    Depends { name: "cpp" }

    //cpp.rule.applicationLinker.condition: false

    property path pythonPath: { return path + "/../../../python3/python3.exe" }
    property string serialPort: "COM1"
    property string serialPortBaud: "460800" // "115200"
    property path esptoolPath: { return path + "/../../../esp8266-2.6.3/Tools/esptool.exe" }
    property path elf2binPath: { return path + "/../../../esp8266-2.6.3/Tools/elf2bin.py" }
    property path uploadPath: { return path + "/../../../esp8266-2.6.3/Tools/upload.py" }
    property path bootloaderPath: { return path + "/../../../esp8266-2.6.3/Bootloaders/eboot/eboot.elf" }

    qbs.architecture: "xtensa-lx106-elf"
    cpp.architecture: "xtensa-lx106-elf"
    //    qbs.enableDebugCode: "manual"
    //    qbs.debugInformation: false
    //    cpp.debugInformation: false
    cpp.warningLevel: "manual"
    //    cpp.visibility: "manual"
    cpp.visibility: undefined
    cpp.enableRtti: undefined
    cpp.positionIndependentCode: false
    cpp.linkerMode: "manual"
    cpp.linkerName: "gcc"
    cpp.enableExceptions: false

    cpp.shouldLink:false
    cpp.optimization: "small"
    //    cpp.debugInformation: true
    //cpp.cxxLanguageVersion: "gnu++11"

    cpp.defines: [
        "NO_GLOBAL_INSTANCES",
        "__ets__",
        "F_CPU=80000000L",
        "NONOSDK22x_190703=1",

        "ARDUINO=10805",
        "ARDUINO_ESP8266_NODEMCU",
        "ARDUINO_ARCH_ESP8266",
        "ARDUINO_BOARD=\"ESP8266_NODEMCU\"",
        "FLASHMODE_QIO",
        "ESP8266"
    ]

    cpp.commonCompilerFlags: [
        "-Os",
        "-MMD",
        "-U__STRICT_ANSI__",
        "-nostdlib",
        "-mlongcalls",
    ]

    cpp.assemblerFlags: [
        "-x",
        "assembler-with-cpp",
    ]

    cpp.cFlags: [
        "-Wpointer-arith",
        "-Wno-implicit-function-declaration",
        "-Wl,-EL",
        "-std=gnu99",
        "-fno-inline-functions",
        "-mtext-section-literals",
        "-falign-functions=4",
        "-ffunction-sections",
        "-fdata-sections",
    ]

    cpp.cxxFlags: [
        "-std=c++11",
        "-mtext-section-literals",
        "-fno-exceptions",
        "-fno-rtti",
        "-falign-functions=4",
        "-ffunction-sections",
        "-fdata-sections",
    ]

    cpp.linkerFlags: [
        "-Os",
        "-nostdlib",
        "-Wl,--no-check-sections",
        "-u call_user_start",
        "-Wl,-static",
        "-Wl,--gc-sections",
        //"-Wl,-wrap,system_restart_local",
        //"-Wl,-wrap,register_chipv6_phy",
        "-Wl,-wrap,system_restart_local",
        "-Wl,-wrap,spi_flash_read",
    ]

    Rule {
        name: "staticLibraryLinker"
        condition: true
        multiplex: true
        inputs: ["obj", "linkerscript"]
        inputsFromDependencies: ["staticlibrary"]
        Artifact {
            fileTags: ["staticlibrary"]
            filePath: product.name + ".a"
        }
        prepare: {
            var args = ['rcs', output.filePath];
            for (var i in inputs.obj)
                args.push(inputs.obj[i].filePath);
            var cmd = new Command(product.cpp.archiverPath, args);
            cmd.description = 'Creating ' + output.fileName;
            cmd.highlight = 'linker'
            cmd.responseFileUsagePrefix = '@';
            return cmd;
        }
    }

    Rule {
        name: "applicationLinker"
        multiplex: true
        inputs: ["obj", "linkerscript"]
        inputsFromDependencies: ["staticlibrary"]
        Artifact {
            fileTags: ["elf"]
            filePath: product.name + ".elf"
        }
        prepare: {
            var compilers = product.cpp.compilerPathByLanguage;
            var linkerPath = compilers["c"]

            var args = [];

            args = args.concat(product.cpp.linkerFlags)
            args = args.concat(product.cpp.driverFlags)

            args.push('-o');
            args.push(output.filePath);

            for (i in inputs.linkerscript)
                args.push("-T" + inputs.linkerscript[i].filePath);

            if(product.cpp.libraryPaths)
            {
                for (i in product.cpp.libraryPaths)
                    args.push("-L" + product.cpp.libraryPaths[i]);
            }

            args.push("-Wl,--start-group");

            for (i in inputs["obj"])
                args.push(inputs["obj"][i].filePath);

            if(inputs.staticlibrary)
            {
                for (i in inputs.staticlibrary)
                    args.push(inputs.staticlibrary[i].filePath);
            }

            for (i in product.cpp.staticLibraries)
                args.push("-l" + product.cpp.staticLibraries[i]);

            args.push("-Wl,--end-group");


            var cmd = new Command(linkerPath , args);
            cmd.description = 'Linking ' + product.name;
            cmd.highlight = "linker";

            return [cmd];
        }
    }


    Rule
    {
        name: "elfToFirmware"
        condition: false
        inputs: ["elf"]
        Artifact
        {
            filePath: input.baseName + ".bin"
            fileTags: "firmware"
        }
        prepare:
        {
            var args = [
                        "-eo", product.ESP8266Module.bootloaderPath,
                        "-bo",output.filePath,
                        "-bm","dio","-bf","40","-bz","4M","-bs",".text","-bp","4096","-ec",
                        "-eo",input.filePath,
                        "-bs",".irom0.text","-bs",".text","-bs",".data","-bs",".rodata","-bc","-ec"
                    ];
            var cmd = new Command(product.ESP8266Module.esptoolPath, args);
            cmd.description = "Generate: " + output.fileName;
            cmd.highlight = "linker";
            return [cmd];
        }
    }

    Rule
    {
        name: "elfToFirmware"
        inputs: ["elf"]
        Artifact
        {
            filePath: input.baseName + ".bin"
            fileTags: "firmware"
        }
        prepare:
        {
            prepare:
            {
                var args = [
                            product.ESP8266Module.elf2binPath,
                            "--eboot", product.ESP8266Module.bootloaderPath,
                            "--app", input.filePath,
                            "--flash_mode", "dio",
                            "--flash_freq", "40",
                            "--flash_size", "4M",
                            "--path", product.cpp.toolchainInstallPath,
                            "--out", output.filePath
                        ];
                var cmd = new Command(product.ESP8266Module.pythonPath, args);
                cmd.description = "Generate: " + output.fileName;
                cmd.highlight = "linker";
                return [cmd];
            }
        }
    }

    Rule
    {
        id: sizeinfo
        inputs: ["elf"]
        Artifact
        {
            //filePath: input.baseName + ".sizeinfo"
            fileTags: "sizeinfo"
        }
        prepare:
        {
            var appSizePath = FileInfo.path(product.cpp.compilerPathByLanguage["c"]);
            appSizePath += "/xtensa-lx106-elf-size";
            var appSizeArgs = [ input.filePath ];
            var appSizeCmd = new Command(appSizePath, appSizeArgs);
            appSizeCmd.description = "sizeinfo";
            appSizeCmd.highlight = "linker";
            return [appSizeCmd];
        }
    }

    Rule
    {
        name: "uploader"
        condition: false
        inputs: ["firmware"]
        Artifact
        {
            filePath: input.baseName + ".upload.bat"
            fileTags: "application"
        }
        prepare:
        {
            var cmd = new JavaScriptCommand();
            cmd.description = "Generate: " + output.fileName;
            cmd.highlight = "codegen";
            cmd.sourceCode = function() {
                file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.write(product.ESP8266Module.esptoolPath);
                file.write(" -cp " + product.ESP8266Module.serialPort);
                file.write(" -cb 115200");
                //file.write(" -cb 230400");
                file.write(" -cd nodemcu");
                //file.write(" -ce");
                file.write(" -ca 0x00000");
                file.write(" -cf " + input.filePath);
                file.close();
            }
            return [cmd];
        }
    }

    Rule
    {
        name: "uploader"
        inputs: ["firmware"]
        Artifact
        {
            filePath: input.baseName + ".upload.bat"
            fileTags: "application"
        }
        prepare:
        {
            var cmd = new JavaScriptCommand();
            cmd.description = "Generate: " + output.fileName;
            cmd.highlight = "codegen";
            cmd.sourceCode = function() {
                file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.write(product.ESP8266Module.pythonPath + " " + product.ESP8266Module.uploadPath);
                file.write(" --chip esp8266");
                file.write(" --port " + product.ESP8266Module.serialPort);
                //file.write(" --baud 115200");
                file.write(" --baud " + product.ESP8266Module.serialPortBaud);
                file.write(" --before default_reset");
                file.write(" --after hard_reset");
                file.write(" write_flash 0x0 " + input.filePath);
                file.close();
            }
            return [cmd];
        }
    }

}
