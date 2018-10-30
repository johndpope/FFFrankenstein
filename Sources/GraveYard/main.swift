//
//  Main.swift
//  GraveYard
//
//  Created by Mark Malstrom on 10/29/18.
//

import Foundation
import FFrankenstein

// let video = try Video(at: "~/Movies/Big Buck Bunny.mkv")

let probe = try Command.run(.ffprobe, arguments: [
    "-i", "~/Movies/Big Buck Bunny.mkv".expandingTildeInPath(), "-print_format",
    "json", "-show_format",
    "-show_streams", "-show_error"
])
    
let start: String.Index = probe.startIndex // probe.range(of: "\"streams\": [")!.first
let end = probe.endIndex

let json = probe[start..<end]

print(probe)

//print(video.length)
//print(video.bitrate)
//print(video.size)
//print()
//
//print(video.videoStream)
//print(video.videoCodec?.rawValue ?? "No codec.")
//print(video.colorSpace)
//print(video.resolution)
//print(video.width)
//print(video.height)
//print(video.frameRate)
//print()
//
//print(video.audioCodec?.rawValue ?? "No codec.")
//print(video.audioSampleRate)
//print(video.audioChannels)
//print()
//
//var progressBar = 0.0
//let outputVideo = video.transcode(to: "~/Movies/Big Buck Bunny.mp4") { progressBar += $0 }
//
//print(outputVideo.size)
//print(outputVideo.videoCodec?.rawValue ?? "No codec.")
//print(outputVideo.audioCodec?.rawValue ?? "No codec.")
//print()
