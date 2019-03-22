//
//  Command.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 6/12/18.
//

import Foundation
import SDGExternalProcess

enum Command {
    private enum Executable {
        static let ffmpeg = ExternalProcess(at: URL(fileURLWithPath: "/usr/local/bin/ffmpeg"))
        static let ffprobe = ExternalProcess(at: URL(fileURLWithPath: "/usr/local/bin/ffprobe"))
    }
    
    static func ffmpeg(input: String, inputArguments: [String: String], outputArguments: [String: String], oputput: String) throws {
        var args = ["-nostdin"]
        
        inputArguments.forEach { (element) in
            args.append(element.key)
            args.append(element.value)
        }
        
        args.append(contentsOf: ["-i", input])
        
        outputArguments.forEach { (element) in
            args.append(element.key)
            args.append(element.value)
        }
        
        args.append(oputput)
        try Executable.ffmpeg.run(args)
    }
    
    static func ffprobe(input: String) throws -> String {
        return try Executable.ffprobe.run([
            "-v", "quiet", "-print_format",
            "json", "-show_format", "-show_streams",
            input
        ])
    }    
}
