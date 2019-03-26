//
//  Codecs.swift
//  FFFrankenstein
//
//  Created by Mark Malstrom on 3/21/19.
//

import Foundation

extension FFFrankenstein {
    public struct Codec {
        public let type: CodecType
        public let name: CodecName
    }
}

extension FFFrankenstein.Codec {
    public enum CodecType: String, Decodable {
        case video
        case audio
    }
    
    public enum CodecName: RawRepresentable, CustomStringConvertible, Decodable {
        public enum ProResEncoder: String {
            case aw, ks
        }
        
        /// One is not always faster than the other,
        /// but one or the other may be better suited to a particular system
        public enum AC3Encoder: String {
            /// This encoder uses floating-point math
            case floatingPoint = ""
            /// This encoder only uses fixed-point integer math
            case fixedPointInteger = "_fixed"
        }
        
        public typealias RawValue = String
        
        case h264, h265, vp8, vp9, av1, xvid, mpeg2
        case prores(ProResEncoder)
        case flac, opus, mp3, vorbis, wav
        case ac3(AC3Encoder), aac(useFDK: Bool)
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
            case "aac":
                self = .aac(useFDK: false)
            case "libfdk_aac":
                self = .aac(useFDK: true)
            case "ac3":
                self = .ac3(.floatingPoint)
            case "ac3_fixed", "ac3-fixed", "ac3 fixed", "ac3fixed":
                self = .ac3(.fixedPointInteger)
            case "mp3", "libmp3lame":
                self = .mp3
            case "vorbis", "libvorbis":
                self = .vorbis
            case "wav", "wavpack":
                self = .wav
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
            case .ac3(let encoder):
                return "ac3\(encoder))"
            case .flac:
                return "flac"
            case .aac(let useFDK):
                if useFDK { return "libfdk_aac" }
                return "aac"
            case .opus:
                return "opus"
            case .mp3:
                return "libmp3lame"
            case .vorbis:
                return "libvorbis"
            case .wav:
                return "wavpack"
            case .copy:
                return "copy"
            case .other(let codec):
                return codec
            }
        }
        
        public var description: String {
            return rawValue
        }
    }
}
