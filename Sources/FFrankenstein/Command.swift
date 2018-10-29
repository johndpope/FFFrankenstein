//
//  Command.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 6/12/18.
//

import Foundation

struct Command {
    public enum Error: Swift.Error, LocalizedError {
        case unknownError(stderr: String, statusCode: Int)
        case unknownFileType
        case noSuchFileOrDirectory
        
        var errorDescription: String? {
            switch self {
            case let .unknownError(err, code):
                return String(localizedKey: "An unknown error with status \(code) occured: \(err)")
            case .unknownFileType:
                return String(localizedKey: "The file you are trying to convert is invalid or may not exist.")
            case .noSuchFileOrDirectory:
                return String(localizedKey: "The file you are trying to convert does not exist.")
            }
        }
    }
    
    enum Executable: String {
        case ffprobe = "/usr/local/bin/ffprobe"
        case ffmpeg = "/usr/local/bin/ffmpeg"
        case trash = "/usr/local/bin/trash"
    }

    @discardableResult
    static func run(_ executable: Executable, arguments: [String]) throws -> String {
        let process = Process()
        process.launchPath = executable.rawValue
        process.arguments = arguments
        return try process.launchWithOutput()
    }

    @discardableResult
    static func run(_ executable: Executable, arguments: String) throws -> String {
        return try Command.run(executable, arguments: [arguments])
    }

    static func which(_ program: String) throws -> Bool {
        // True if program exists, false if not
        let process = Process()
        process.launchPath = "/usr/bin/which"
        process.arguments = [program]
        process.environment = ProcessInfo.processInfo.environment
        return try !process.launchWithOutput().isEmpty
    }

    static func brewInstall(_ packageName: String, options: [String] = []) throws {
        if try !Command.which("brew") {
            try Command.installHomebrew()
        }

        print("Installing \(packageName)...")

        let process = Process()
        process.launchPath = "/usr/local/bin/brew"
        process.arguments = ["install", packageName] + options
        try process.launchWithOutput()
    }

    private static func installHomebrew() throws {
        print("Installing homebrew...")
        let process = Process()
        process.launchPath = "/usr/bin/ruby"
        process.arguments = [
            "-e",
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)".encapsulated(),
        ]
        try process.launchWithOutput()
    }
}

private extension Process {
    @discardableResult
    func launchWithOutput(outputHandle: FileHandle? = nil, errorHandle: FileHandle? = nil) throws -> String {
        let outputQueue = DispatchQueue(label: "bash-output-queue")

        var outputData = Data()
        var errorData = Data()

        let outputPipe = Pipe()
        standardOutput = outputPipe

        let errorPipe = Pipe()
        standardError = errorPipe

        outputPipe.fileHandleForReading.readabilityHandler = { handler in
            outputQueue.async {
                let data = handler.availableData
                outputData.append(data)
                outputHandle?.write(data)
            }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            outputQueue.async {
                let data = handler.availableData
                errorData.append(data)
                errorHandle?.write(data)
            }
        }

        launch()
        waitUntilExit()

        outputHandle?.closeFile()
        errorHandle?.closeFile()

        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil

        switch terminationStatus {
        case 0: return outputData.shellOutput()
        case 1: return ""
        default:
            let errorMessage = errorData.shellOutput()

            if errorMessage.contains("No such file or directory") {
                throw Command.Error.noSuchFileOrDirectory
            } else {
                throw Command.Error.unknownError(
                    stderr: errorMessage,
                    statusCode: Int(terminationStatus)
                )
            }
        }
    }
}

private extension Data {
    func shellOutput() -> String {
        guard let output = String(data: self, encoding: .utf8) else {
            return ""
        }

        guard !output.hasSuffix("\n") else {
            let endIndex = output.index(before: output.endIndex)
            return String(output[..<endIndex])
        }

        return output
    }
}
