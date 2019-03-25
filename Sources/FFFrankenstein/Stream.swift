//
//  Stream.swift
//  FFFrankenstein
//
//  Created by Mark Malstrom on 3/24/19.
//

import Foundation

extension FFFrankenstein {
    internal struct FFProbeOutput: Decodable {
        let streams: [FFFrankenstein.Stream]
        let format: FFFrankenstein.Format
    }
}

extension FFFrankenstein {
    public struct Stream: Decodable {
        private let codecName: Codec.CodecName
        private let codecType: Codec.CodecType
        private let codecTagHex: String
        private let is_avc: String
        
        public var codec: Codec {
            return Codec(type: codecType, name: codecName)
        }
        
        public var codecTag: Int? {
            return Int(codecTagHex, radix: 16)
        }
        
        public var isAVC: Bool {
            return is_avc == "true"
        }
        
        public let codecLongName: String
        public let index: UInt
        public let profile: String?
        public let codecTimeBase: String
        public let codecTagString: String
        public let width: UInt?
        public let height: UInt?
        public let codedWidth: UInt?
        public let codedHeight: UInt?
        public let amountOfBFrames: UInt?
        public let sampleAspectRatio: String?
        public let displayAspectRatio: String?
        public let pixelFormat: String?
        public let level: Int?
        public let chromaLocation: String?
        public let fieldOrder: String?
        public let references: Int?
        public let nalLengthSize: String?
        public let rFrameRate: String
        public let averageFrameRate: String
        public let timeBase: String
        public let startPoints: Int
        public let startTime: String
        public let bitsPerRawSample: String?
        public let disposition: [String: Int]
        public let tags: Stream.Tags
        public let sampleFmt: String?
        public let sampleRate: String?
        public let channels: Int?
        public let channelLayout: String?
        public let bitsPerSample: Int?
        public let dmixMode: String?
        public let ltrtCmixlev: String?
        public let ltrtSurmixlev: String?
        public let loroCmixlev: String?
        public let loroSurmixlev: String?
        public let bitRate: String?
        
        enum CodingKeys: String, CodingKey {
            case index
            case codecName = "codec_name"
            case codecLongName = "codec_long_name"
            case profile
            case codecType = "codec_type"
            case codecTimeBase = "codec_time_base"
            case codecTagString = "codec_tag_string"
            case codecTagHex = "codec_tag"
            case width, height
            case codedWidth = "coded_width"
            case codedHeight = "coded_height"
            case amountOfBFrames = "has_b_frames"
            case sampleAspectRatio = "sample_aspect_ratio"
            case displayAspectRatio = "display_aspect_ratio"
            case pixelFormat = "pix_fmt"
            case level
            case chromaLocation = "chroma_location"
            case fieldOrder = "field_order"
            case references = "refs"
            case is_avc
            case nalLengthSize = "nal_length_size"
            case rFrameRate = "r_frame_rate"
            case averageFrameRate = "avg_frame_rate"
            case timeBase = "time_base"
            case startPoints = "start_pts"
            case startTime = "start_time"
            case bitsPerRawSample = "bits_per_raw_sample"
            case disposition, tags
            case sampleFmt = "sample_fmt"
            case sampleRate = "sample_rate"
            case channels
            case channelLayout = "channel_layout"
            case bitsPerSample = "bits_per_sample"
            case dmixMode = "dmix_mode"
            case ltrtCmixlev = "ltrt_cmixlev"
            case ltrtSurmixlev = "ltrt_surmixlev"
            case loroCmixlev = "loro_cmixlev"
            case loroSurmixlev = "loro_surmixlev"
            case bitRate = "bit_rate"
        }
    }
}

extension FFFrankenstein.Stream {
    public struct Tags: Decodable {
        public let handlerName: String
        public let duration: String
        
        enum CodingKeys: String, CodingKey {
            case handlerName = "HANDLER_NAME"
            case duration = "DURATION"
        }
    }
}
