//
//  FFBuilder.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 3/21/19.
//

import Foundation

func += <K, V> (left: inout [K: V], right: [K: V]) {
    for (k, v) in right {
        left[k] = v
    }
}

extension String: Error {}

public class FFFrankenstein {
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
    public func videoCodec(_ codec: VideoCodec) -> FFFrankenstein {
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
    
    // FIXME: Enforce
    // Calls to aspect() are ignored when size() has been called with a fixed width and height or a percentage, and also
    /**
     Set the output frame aspect ratio
     
     **NOTE:** Calls to aspect() are ignored when size() has not been called
     */
    public func aspect(_ ratio: String) throws -> FFFrankenstein {
        guard outputOptions["-s:v"] != nil else {
            // FIXME: Make this a real error.
            throw """
            You tried to set the aspect ratio on an instance of FFFrankenstein
            that didn't have its size set yet.
            
            See the documentation for more information about this.
            """
        }
        
        outputOptions["-aspect:v"] = ratio
        return self
    }

    /**
     Set the output frame aspect ratio
     
     **NOTE:** Calls to aspect() are ignored when size() has not been called
     */
    public func aspect(_ ratio: Double) throws -> FFFrankenstein {
        return try aspect("\(ratio)")
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
    public func audioCodec(_ codec: AudioCodec) -> FFFrankenstein {
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
        try Command.ffmpeg(
            input: input,
            inputArguments: inputOptions,
            outputArguments: outputOptions,
            oputput: output
        )
    }
    
    public func save(to path: String) throws {
        try output(path).run()
    }
    
    // TODO: EventEmitter-like observables
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#setting-event-handlers
    
    // TODO: Concatenate multiple inputs
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#mergetofilefilename-tmpdir-concatenate-multiple-inputs
    
    // TODO: Generate screenshot thumbnails
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#screenshotsoptions-dirname-generate-thumbnails
    
    // TODO: Kill the currently running ffmpeg process
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#killsignalsigkill-kill-any-running-ffmpeg-process
    
    // TODO: ffprobe methods
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#reading-video-metadata
    
    // TODO: Querying ffmpeg capabilities
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#querying-ffmpeg-capabilities
    
    // TODO: Cloning
    // https://github.com/fluent-ffmpeg/node-fluent-ffmpeg#cloning-an-ffmpegcommand
}
