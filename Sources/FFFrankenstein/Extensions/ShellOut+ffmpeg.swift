//
//  ShellOut+ffmpeg.swift
//  FFFrankenstein
//
//  Created by Mark Malstrom on 3/25/19.
//

import Foundation
import ShellOut

public extension ShellOutCommand {
    static func ffmpeg(input: String,
                       inputArguments: [String: String],
                       outputArguments: [String: String],
                       output: String) -> ShellOutCommand {
        
        var command = "ffmpeg -nostdin"
        
        inputArguments.forEach { (element) in
            command.append(" \(element.key)")
            command.append(" \(element.value)")
        }
        
        command.append(" -i \(input)")
        
        outputArguments.forEach { (element) in
            command.append(" \(element.key)")
            command.append(" \(element.value)")
        }
        
        command.append(" \(output)")
        
        return ShellOutCommand(string: command)
    }
    
    static func ffprobe(input: String) -> ShellOutCommand {
        return ShellOutCommand(string: "ffprobe -v quiet -print_format json -show_format -show_streams \(input)")
    }
}
