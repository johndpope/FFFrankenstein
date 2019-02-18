//
//  FFrankenstein.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 2/17/19.
//

import Foundation
import Path

public struct FFrankenstein {
    private let input: Path
    private let metadata: String
    var output: Path? = nil
    
    private var runCommands: [String] = []
    
    init(_ input: Path) throws {
        self.input = input
        self.metadata = try Command.ffprobe(input: input)
    }
    
    // FIXME: How should this handle switching after setting?
    // Don't want to end up with 12 different codecs appended to the runCommands
    //
    // FIXME: if metadata.videoCodec == self.videoCodec, videoCodec should be copy
    // No need to reencode the same codec
    var videoCodec: VideoCodec {
        didSet {
            runCommands.append("-c:v")
            runCommands.append(videoCodec.rawValue)
        }
    }
    
    // FIXME: How should this handle switching after setting?
    // FIXME: if metadata.audioCodec == self.audioCodec, audioCodec should be copy
    var audioCodec: AudioCodec {
        didSet {
            runCommands.append("-c:a")
            runCommands.append(audioCodec.rawValue)
        }
    }
    
    /// - Parameter arguments: These arguments will overwrite any previously set options
    func run(with arguments: [String]? = nil) throws {
        guard let output = output else {
            throw "Must set output path to run."
        }
        
        if let arguments = arguments {
            try Command.ffmpeg(input: input, arguments: arguments, oputput: output)
        } else {
            try Command.ffmpeg(input: input, arguments: runCommands, oputput: output)
        }
    }
}

extension FFrankenstein {
    public enum VideoCodec: RawRepresentable {
        public enum ProResEncoder: String {
            case aw, ks
        }
        
        public typealias RawValue = String
        
        case h264, h265, vp8, vp9, av1, xvid, mpeg2
        case prores(ProResEncoder)
        case copy
        case other(String)
        
        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case "h264", "libx264":
                self = .h264
            case "h265", "libx265":
                self = .h265
            case "vp8", "libvpx":
                self = .vp8
            case "vp9", "libvpx-vp9":
                self = .vp9
            case "av1", "libaom":
                self = .av1
            case "xvid", "libxvid":
                self = .xvid
            case "mpeg2":
                self = .mpeg2
            case "prores", "prores-aw":
                self = .prores(.aw)
            case "prores-ks":
                self = .prores(.ks)
            default:
                self = .other(rawValue)
            }
        }
        
        public var rawValue: String {
            switch self {
            case .h264:
                return "libx264"
            case .h265:
                return "libx265"
            case .vp8:
                return "libvpx"
            case .vp9:
                return "libvpx-vp9"
            case .av1:
                return "libaom"
            case .xvid:
                return "libxvid"
            case .mpeg2:
                return "mpeg2"
            case .prores(let encoder):
                return "prores-\(encoder.rawValue)"
            case .copy:
                return "copy"
            case .other(let codec):
                return codec
            }
        }
    }
    
    public enum AudioCodec: RawRepresentable {
        /// One is not always faster than the other,
        /// but one or the other may be better suited to a particular system
        public enum AC3Encoder: String {
            /// This encoder uses floating-point math
            case floatingPoint = ""
            /// This encoder only uses fixed-point integer math
            case fixedPointInteger = "_fixed"
        }
        
        public typealias RawValue = String
        
        case ac3(AC3Encoder)
        case aac(useFDK: Bool)
        case flac, opus, fdk_aac, mp3, vorbis, wav
        case copy
        case other(String)
        
        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case "aac":
                self = .aac(useFDK: false)
            case "libfdk_aac":
                self = .aac(useFDK: true)
            case "ac3":
                self = .ac3(.floatingPoint)
            case "ac3_fixed", "ac3-fixed", "ac3 fixed", "ac3fixed":
                self = .ac3(.fixedPointInteger)
            default:
                self = .other(rawValue)
            }
        }
        
        public var rawValue: String {
            switch self {
            case .ac3(let encoder):
                return "ac3\(encoder))"
            case .flac:
                return "flac"
            case .aac(let useFDK):
                if useFDK { return "libfdk_aac" }
                return "aac"
            case .opus:
                return "opus"
            case .fdk_aac:
                <#code#>
            case .mp3:
                <#code#>
            case .vorbis:
                <#code#>
            case .wav:
                <#code#>
            case .copy:
                <#code#>
            case .other(let codec):
                return codec
            }
        }
    }
}
