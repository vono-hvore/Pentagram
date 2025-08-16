//
//  Logger.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 25.06.2025.
//

@globalActor actor Logger {
    static var shared: Logger {
        #if DEBUG
            return Logger(.verbose)
        #else
            return Logger(.info)
        #endif
    }

    private let rootLevel: Level

    init(_ level: Level = .info) {
        rootLevel = level
    }

    nonisolated func log(_ message: String, level: Level = .info) {
        Task { @Logger in
            guard rootLevel.shouldLog(for: level) else { return }

            print(message)
        }
    }
}

extension Logger {
    enum Level {
        case verbose
        case info
        case silent

        func shouldLog(for state: Level) -> Bool {
            return switch (self, state) {
            case (.verbose, _): true
            case (.info, .info), (.info, .silent): true
            case (.silent, .silent): true
            default: false
            }
        }
    }
}
