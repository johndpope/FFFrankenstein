//
//  FFFrankenstein.swift
//  FFFrankenstein
//
//  Created by Mark Malstrom on 3/21/19.
//

import Foundation
import ShellOut

open class FFFrankenstein {
    private var input = String()
    private var inputOptions = [String: String]()
    private var outputOptions = [String: String]()
    private var output = String()
    
    public func inputOptions(_ opts: [String: String]) -> FFFrankenstein {
        inputOptions += opts
        return self
    }
    
    /// Set the input file
    public func input(_ path: String) -> FFFrankenstein {
        input = path
        return self
    }
    
    /// Set the video codec
    public func videoCodec(_ codec: String) -> FFFrankenstein {
        outputOptions["-c:v"] = codec
        return self
    }
    
    /// Set the video codec
    public func videoCodec(_ codec: Codec.CodecName) -> FFFrankenstein {
        return videoCodec("\(codec)")
    }
    
    /// Disable video altogether
    public func noVideo() -> FFFrankenstein {
        outputOptions["-vn"] = ""
        return self
    }
    
    /// Set the video bitrate
    public func videoBitrate(_ bitrate: UInt) -> FFFrankenstein {
        outputOptions["-b:v"] = "\(bitrate)"
        return self
    }
    
    /// Set the output framerate
    public func fps(_ frameRate: Double) -> FFFrankenstein {
        outputOptions["-r:v"] = "\(frameRate)"
        return self
    }
    
    /// Set the number of video frames to output
    public func frames(_ count: UInt) -> FFFrankenstein {
        outputOptions["-frames:v"] = "\(count)"
        return self
    }
    
    /// Set the output frame size
    public func size(_ size: String) -> FFFrankenstein {
        outputOptions["-s:v"] = size
        return self
    }
    
    /**
     Set the output frame aspect ratio
     
     **NOTE:** Calls to aspect() are ignored when size() has been called with a fixed width and height or a percentage, and also when size() has not been called
     */
    public func aspect(_ ratio: String) -> FFFrankenstein {
        guard let sizeOpt = outputOptions["-s:v"],
            sizeOpt.range(of: "%") == nil,
            sizeOpt.range(of: "?") != nil else {
            return self
        }
        
        outputOptions["-aspect:v"] = ratio
        return self
    }

    /**
     Set the output frame aspect ratio
     
     **NOTE:** Calls to aspect() are ignored when size() has been called with a fixed width and height or a percentage, and also when size() has not been called
     */
    public func aspect(_ ratio: Double) -> FFFrankenstein {
        return aspect("\(ratio)")
    }
    
    /// Set the output duration
    public func duration(_ time: String) -> FFFrankenstein {
        outputOptions["-t"] = time
        return self
    }
    
    /// Set the output duration
    public func duration(_ time: Double) -> FFFrankenstein {
        return duration("\(time)")
    }
    
    /// Set the output format
    public func format(_ format: String) -> FFFrankenstein {
        outputOptions["-f"] = format
        return self
    }
    
    /// Set the audio codec
    public func audioCodec(_ codec: String) -> FFFrankenstein {
        outputOptions["-c:a"] = codec
        return self
    }
    
    /// Set the audio codec
    public func audioCodec(_ codec: Codec.CodecName) -> FFFrankenstein {
        return audioCodec("\(codec)")
    }
    
    /// Disable audio altogether
    public func noAudio() -> FFFrankenstein {
        outputOptions["-an"] = ""
        return self
    }
    
    /// Set the audio bitrate
    public func audioBitrate(_ bitrate: UInt) -> FFFrankenstein {
        outputOptions["-b:a"] = "\(bitrate)"
        return self
    }
    
    /// Set the audio channel count
    public func audioChannels(_ count: UInt) -> FFFrankenstein {
        outputOptions["-ac"] = "\(count)"
        return self
    }
    
    /// Set the audio frequency in Hz
    public func audioFrequency(_ freq: UInt) -> FFFrankenstein {
        outputOptions["-ar"] = "\(freq)"
        return self
    }
    
    /// Set the audio frequency in Hz
    public func audioQuality(_ quality: UInt) -> FFFrankenstein {
        outputOptions["-q:a"] = "\(quality)"
        return self
    }
    
    public func outputOptions(_ opts: [String: String]) -> FFFrankenstein {
        outputOptions += opts
        return self
    }
    
    /// Set the path for the output file
    ///
    /// NOTE: Must be called after all other options are set to work properly
    public func output(_ path: String) -> FFFrankenstein {
        output = path
        return self
    }
    
    public func run() throws {
        try shellOut(to: .ffmpeg(
            input: input,
            inputArguments: inputOptions,
            outputArguments: outputOptions,
            output: output))
    }
    
    public func save(to path: String) throws {
        try output(path).run()
    }
    
    public func streams() throws -> [Stream] {
        guard !input.isEmpty else {
            throw "Cannot access streams before setting an input."
        }
        
        let rawString = try shellOut(to: .ffprobe(input: input))
        
        guard let data = rawString.data(using: .utf8) else {
            throw "ffprobe data could not be synthesized."
        }
        
        return try FFProbeOutput(from: data).streams
    }
    
    /// - Returns: The first stream with the codec type passed in
    public func stream(for codecType: Codec.CodecType) throws -> Stream {
        let strms = try streams()
        for stream in strms where stream.codec.type == codecType {
            return stream
        }
        
        throw "Could not find a stream with a \(codecType) codec type."
    }
    
    public func formatMetadata() throws -> Format {
        guard !input.isEmpty else {
            throw "Cannot access format metadata before setting an input."
        }
        
        let rawString = try shellOut(to: .ffprobe(input: input))
        
        guard let data = rawString.data(using: .utf8) else {
            throw "ffprobe data could not be synthesized."
        }
        
        return try FFProbeOutput(from: data).format
    }
    
    /**
     Copy an FFFrankenstein instance.
     
     This method is useful when you want to process the same input multiple times.
     It returns a new FFFrankenstein instance with the exact same options.
     
     All options set *after* the `copy()` call will only be applied to the instance
     it has been called on.
     */
    public func copy() -> FFFrankenstein {
        let copy = FFFrankenstein()
        copy.input = self.input
        copy.inputOptions = self.inputOptions
        copy.outputOptions = self.outputOptions
        copy.output = self.output
        return copy
    }
    
    // TODO: EventEmitter-like observables
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#setting-event-handlers
    // https://www.swiftbysundell.com/posts/observers-in-swift-part-1
    // https://www.swiftbysundell.com/posts/observers-in-swift-part-2
    
    // TODO: Add a progress callback
    // https://github.com/kkroening/ffmpeg-python/issues/43
    
    // TODO: Concatenate multiple inputs
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#mergetofilefilename-tmpdir-concatenate-multiple-inputs
    
    // TODO: Generate screenshot thumbnails
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#screenshotsoptions-dirname-generate-thumbnails
    
    // TODO: Kill the currently running ffmpeg process
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#killsignalsigkill-kill-any-running-ffmpeg-process
    
    // TODO: Querying ffmpeg capabilities
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#querying-ffmpeg-capabilities
}
