import MiniAudio
import Foundation

@main
struct Example {
    static func main() async throws {
        let file = Bundle.module.bundleURL.appendingPathComponent("loop.mp3")
        let engine = try Engine()
        let sounds = [
            try engine.loadSound(file),
            try engine.loadSound(file)
        ]
        let duration = try sounds[0].duration

        var soundIndex = 0
        try sounds[0].start()
        soundIndex = (soundIndex + 1) % 2

        if #available(macOS 10.15, *) {
            let delay = duration - 0.8
            while true {
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                let sound = sounds[soundIndex]
                try sound.seek(toSecond: 0)
                try sound.start()
                soundIndex = (soundIndex + 1) % 2
            }
        } else {
            Foundation.sleep(UInt32(duration.rounded(.up)))
        }
    }
}
