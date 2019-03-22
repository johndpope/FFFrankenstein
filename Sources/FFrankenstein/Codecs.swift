//
//  Codecs.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 3/21/19.
//

import Foundation

extension FFFrankenstein {
    public enum VideoCodec: RawRepresentable, CustomStringConvertible {
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
        
        public var description: String {
            return rawValue
        }
    }
    
    public enum AudioCodec: RawRepresentable, CustomStringConvertible {
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
        case flac, opus, mp3, vorbis, wav
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
        
        public var description: String {
            return rawValue
        }
    }
}
