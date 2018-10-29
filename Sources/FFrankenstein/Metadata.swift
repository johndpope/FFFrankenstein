//
//  Metadata.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 10/29/18.
//

import Foundation

extension Video {
    public struct Metadata: Decodable {
        public enum CommonCodec: String, Decodable {
            case h264, hevc, flv1
            case acc, ac3, mp3
        }
        
//        enum CommonCodec: RawRepresentable, Decodable {
//            typealias RawValue = String
//
//            case h264, hevc, flv1
//            case acc, ac3, mp3
//            case unknown(String)
//
//            init(from decoder: Decoder) throws {
//                <#code#>
//            }
//
//            init(rawValue: String) {
//                switch rawValue {
//                case "h264": self = .h264
//                case "hevc": self = .hevc
//                case "flv1": self = .flv1
//                case "gif": self = .gif
//                default: self = .unknown(rawValue)
//                }
//            }
//
//            var rawValue: String {
//                switch self {
//                case .h264: return "h264"
//                case .hevc: return "hevc"
//                case .flv1: return "flv1"
//                case .gif: return "gif"
//                case let .unknown(str): return str
//                }
//            }
//        }
        
        enum CodecType: String, Decodable {
            case video, audio
        }
        
        class Stream: Decodable {
            let codec_name: CommonCodec
            let codec_long_name: String
            let codec_type: CodecType
            let start_time: String
            let codec_tag_string: String
            let codec_tag: String
        }
        
        class VideoStream: Stream {
            let profile: String
            let width: UInt
            let height: UInt
            let sample_aspect_ratio: String
            let display_aspect_ratio: String
            // FIXME: Needs a custom enum
            let pix_fmt: String
            let is_avc: String
            let r_frame_rate: String
            let avg_frame_rate: String
            
            enum CodingKeys: String, CodingKey {
                case profile
                case width
                case height
                case sample_aspect_ratio
                case display_aspect_ratio
                case pix_fmt
                case is_avc
                case r_frame_rate
                case avg_frame_rate
            }
            
            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                profile = try container.decode(String.self, forKey: .profile)
                width = try container.decode(UInt.self, forKey: .width)
                height = try container.decode(UInt.self, forKey: .height)
                sample_aspect_ratio = try container.decode(String.self, forKey: .sample_aspect_ratio)
                display_aspect_ratio = try container.decode(String.self, forKey: .display_aspect_ratio)
                pix_fmt = try container.decode(String.self, forKey: .pix_fmt)
                is_avc = try container.decode(String.self, forKey: .is_avc)
                r_frame_rate = try container.decode(String.self, forKey: .r_frame_rate)
                avg_frame_rate = try container.decode(String.self, forKey: .avg_frame_rate)
                
                let superDecoder = try container.superDecoder()
                try super.init(from: superDecoder)
            }
            
            var isAVC: Bool {
                return is_avc == "true"
            }
        }
        
        class AudioStream: Stream {
            // FIXME: Needs a custom enum
            let sample_fmt: String
            let sample_rate: String
            let channels: UInt
            // FIXME: Needs a custom enum
            let channel_layout: String
            let bit_rate: String
            
            enum CodingKeys: String, CodingKey {
                case sample_fmt
                case sample_rate
                case channels
                case channel_layout
                case bit_rate
            }
            
            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                sample_fmt = try container.decode(String.self, forKey: .sample_fmt)
                sample_rate = try container.decode(String.self, forKey: .sample_rate)
                channels = try container.decode(UInt.self, forKey: .channels)
                channel_layout = try container.decode(String.self, forKey: .channel_layout)
                bit_rate = try container.decode(String.self, forKey: .bit_rate)
                
                let superDecoder = try container.superDecoder()
                try super.init(from: superDecoder)
            }
            
            var sampleRate: UInt? {
                return UInt(sample_rate)
            }
            
            var bitrate: UInt? {
                return UInt(bit_rate)
            }
        }
        
        struct Format: Decodable {
            struct Tag: Decodable {
                let title: String
                // FIXME: Needs a custom enum
                let GENRE: String
                let COMPOSER: String
                let ARTIST: String
                let COMMENT: String
                let ENCODER: String
            }
            
            let filename: String
            let nb_streams: UInt
            // FIXME: Needs a custom enum
            let format_name: String
            let format_long_name: String
            let start_time: String
            let duration: String
            let size: String
            let bit_rate: String
            let tag: Tag
            
            var lenght: Double? {
                return Double(duration)
            }
            
            var fileSize: UInt? {
                return UInt(size)
            }
            
            var bitrate: UInt? {
                return UInt(bit_rate)
            }
        }
        
        internal let streams: [Stream]
        internal let format: Format
        
        private func getStreams<T: Stream>() -> [T] {
            var streamz = [T]()
            
            streams.forEach {
                if let stream = $0 as? T {
                    streamz.append(stream)
                }
            }
            
            return streamz
        }
        
        internal var videoStreams: [VideoStream] {
            return getStreams()
        }
        
        internal var audioStreams: [AudioStream] {
            return getStreams()
        }
    }
}
