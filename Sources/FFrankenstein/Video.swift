//
//  Video.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 10/29/18.
//

// https://github.com/streamio/streamio-ffmpeg

import Foundation
import Files

public typealias Path = String

public struct Video {
    public let rawFile: File
    private let metadata: Metadata
    
    public init(at path: Path) throws {
        rawFile = try File(path: path)
        
        let ffprobeOutput = try Command.run(.ffprobe, arguments: [
            "-i", path, "-print_format",
            "json", "-show_format",
            "-show_streams", "-show_error"
        ]).data(using: .utf8)!
        
        metadata = try Metadata(from: ffprobeOutput)
    }
    
    /// Duration of the video, in seconds
    public var length: Double {
        return metadata.format.lenght ?? 0
    }
    /// Bitrate of the video, in kilobits per second (kb/s)
    public var bitrate: UInt {
        return metadata.format.bitrate ?? 0
    }
    /// Size of the video, in bytes
    public var size: UInt {
        return metadata.format.fileSize ?? 0
    }
    
    // MARK: Video properties
    ///
    public var videoStream: String {
        if let stream = metadata.videoStreams.first {
            return """
            \(videoCodec!.rawValue) \(stream.profile) \(stream.codec_tag_string)
            \(stream.codec_tag) \(colorSpace) \(resolution)
            [SAR \(sampleAspectRatio) DAR \(displayAspectRatio)]
            """
        }
        
        return ""
    }
    ///
    public var videoCodec: Metadata.CommonCodec? {
        return metadata.videoStreams.first?.codec_name
    }
    ///
    public var colorSpace: String {
        return metadata.videoStreams.first?.pix_fmt ?? ""
    }
    ///
    public var width: UInt {
        return metadata.videoStreams.first?.width ?? 0
    }
    ///
    public var height: UInt {
        return metadata.videoStreams.first?.width ?? 0
    }
    ///
    public var resolution: String {
        if width != 0, height != 0 {
            return "\(width)×\(height)"
        }
        
        return ""
    }
    ///
    public var sampleAspectRatio: String {
        return metadata.videoStreams.first?.sample_aspect_ratio ?? ""
    }
    ///
    public var displayAspectRatio: String {
        return metadata.videoStreams.first?.display_aspect_ratio ?? ""
    }
    /// Frame rate, in frames per second
    public var frameRate: Double {
        if let stream = metadata.videoStreams.first {
            return Double(stream.avg_frame_rate) ?? 0
        }
        
        return 0
    }
    
    
    // MARK: Audio properties
    ///
//    public var audioStream: String {
//        return
//    }
    ///
    public var audioCodec: Metadata.CommonCodec? {
        return metadata.audioStreams.first?.codec_name
    }
    ///
    public var audioSampleRate: UInt {
        return metadata.audioStreams.first?.sampleRate ?? 0
    }
    ///
    public var audioChannels: UInt {
        return metadata.audioStreams.first?.channels ?? 0
    }
}

extension Video {
    struct Resolution: Codable {
        let width: UInt
        let height: UInt
    }
    
    struct Transcoder {
        struct Options {
            static let `default` = Options()
        }
        
        var options = Options.default
        var timeOut = 30
        var canTimeOut = true
    }
    
    func transcode(
        to output: Path,
        using transcoder: Transcoder = Transcoder(),
        customOptions: String = "",
        _ progressBlock: ((Double) -> Void)? = nil
    ) -> Video {
        fatalError("unimplemented")
    }
    
    func captureStillImage(
        to output: Path,
        at seekTime: Double = 0,
        resolution: Resolution? = nil,
        // Integer between 1 and 31
        quality: UInt? = nil
    ) {
        fatalError("unimplemented")
    }
}
