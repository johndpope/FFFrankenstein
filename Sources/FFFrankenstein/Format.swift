//
//  Format.swift
//  FFFrankenstein
//
//  Created by Mark Malstrom on 3/25/19.
//

import Foundation

extension FFFrankenstein {
    public struct Format: Decodable {
        public let filename: String
        public let nbStreams: Int
        public let nbPrograms: Int
        public let formatName: String
        public let formatLongName: String
        public let startTime: String
        public let duration: String
        public let size: String
        public let bitRate: String
        public let probeScore: Int
        public let tags: Format.Tags
        
        enum CodingKeys: String, CodingKey {
            case filename
            case nbStreams = "nb_streams"
            case nbPrograms = "nb_programs"
            case formatName = "format_name"
            case formatLongName = "format_long_name"
            case startTime = "start_time"
            case duration, size
            case bitRate = "bit_rate"
            case probeScore = "probe_score"
            case tags
        }
    }
}

extension FFFrankenstein.Format {
    public struct Tags: Decodable {
        public let title: String?
        public let genre: String?
        public let majorBrand: String?
        public let minorVersion: String?
        public let compatibleBrands: String?
        public let composer: String?
        public let artist: String?
        public let comment: String?
        public let encoder: String?
        
        enum CodingKeys: String, CodingKey {
            case title
            case genre = "GENRE"
            case majorBrand = "MAJOR_BRAND"
            case minorVersion = "MINOR_VERSION"
            case compatibleBrands = "COMPATIBLE_BRANDS"
            case composer = "COMPOSER"
            case artist = "ARTIST"
            case comment = "COMMENT"
            case encoder = "ENCODER"
        }
    }
}
