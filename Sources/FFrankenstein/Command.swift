//
//  Command.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 6/12/18.
//

import Foundation
import SDGExternalProcess
import Path

enum Command {
    private enum Executable {
        static let which = ExternalProcess(at: URL(fileURLWithPath: "/usr/bin/which"))
        static let ruby = ExternalProcess(at: URL(fileURLWithPath: "/usr/bin/ruby"))
        static let curl = ExternalProcess(at: URL(fileURLWithPath: "/usr/bin/curl"))
        static let brew = ExternalProcess(at: URL(fileURLWithPath: "/usr/local/bin/brew"))
        static let ffmpeg = ExternalProcess(at: URL(fileURLWithPath: "/usr/local/bin/ffmpeg"))
        static let ffprobe = ExternalProcess(at: URL(fileURLWithPath: "/usr/local/bin/ffprobe"))
    }
    
    static func ffmpeg(input: Path, arguments: [String], oputput: Path) throws {
        var args = ["-nostdin", "-i", input.string]
        args.append(contentsOf: arguments)
        args.append(oputput.string)
        try Executable.ffmpeg.run(args)
    }
    
    static func ffprobe(input: Path) throws -> String {
        return try Executable.ffprobe.run([
            "-v", "quiet", "-print_format",
            "json", "-show_format", "-show_streams",
            input.string
        ])
    }
    
    static func brewInstall(_ packageName: String, tap: String? = nil, options: [String] = []) throws {
        if try !Executable.which.run(["brew"]).isEmpty {
            let homebrewInstallScript = "https://raw.githubusercontent.com/Homebrew/install/master/install"
            try Executable.ruby.run(["-e", Executable.curl.run(["-fsSL", homebrewInstallScript])])
        }
        
        var package = String()
        
        if let tap = tap {
            try Executable.brew.run(["tap", tap])
            package.append("\(tap)/")
        }
        
        package.append(packageName)
        try Executable.brew.run(["install", package] + options)
    }
    
//    private static func test() throws {
//        try brewInstall("ffmpeg", tap: "slhck/ffmpeg", options: ["--with-aom", "--with-fdk-aac"])
//    }
}
