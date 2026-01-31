import MiniAudioC
import Foundation

func checkResult(_ result: ma_result) throws {
    if result != MA_SUCCESS {
        let message = String(cString: ma_result_description(result))
        throw MiniAudioError(message: message)
    }
}

public struct MiniAudioError: Foundation.LocalizedError {
    var message: String

    public var errorDescription: String? {
        message
    }
}

public class Engine {
    var engine: ma_engine
    var engineConfig: ma_engine_config

    public init() throws {
        engine = ma_engine()
        engineConfig = ma_engine_config_init()

        try checkResult(ma_engine_init(&engineConfig, &engine))
    }

    public func loadSound(_ file: URL) throws -> Sound {
        try Sound(self, file)
    }
}

public class Sound {
    var sound: ma_sound

    init(_ engine: Engine, _ file: URL) throws {
        sound = ma_sound()
        let result = ma_sound_init_from_file(&engine.engine, file.path, 0, nil, nil, &sound)
        try checkResult(result)
    }

    public func start() throws {
        try checkResult(ma_sound_start(&sound))
    }

    public func stop() throws {
        try checkResult(ma_sound_stop(&sound))
    }

    public func setEndCallback(_ callback: @escaping () -> Void) {
        let data = CCallbackData(callback)
        ma_sound_set_end_callback(
            &sound,
            { data, _ in
                let callback = CCallbackData<() -> Void>.fromPointer(data!).value
                callback()
            },
            data.pointer
        )
    }

    public var duration: Double {
        get throws {
            var duration: Float = 0
            try checkResult(ma_sound_get_length_in_seconds(&sound, &duration))
            return Double(duration)
        }
    }

    public var cursor: Double {
        get throws {
            var cursor: Float = 0
            try checkResult(ma_sound_get_cursor_in_seconds(&sound, &cursor))
            return Double(cursor)
        }
    }

    public func seek(toSecond seconds: Double) throws {
        try checkResult(ma_sound_seek_to_second(&sound, Float(seconds)))
    }

    public var isPlaying: Bool {
        get {
            ma_sound_is_playing(&sound) != 0
        }
    }
}

class CCallbackData<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }

    static func fromPointer(_ pointer: UnsafeMutableRawPointer) -> Self {
        Unmanaged.fromOpaque(pointer)
            .takeUnretainedValue()
    }

    var pointer: UnsafeMutableRawPointer {
        Unmanaged.passRetained(self).toOpaque()
    }
}
