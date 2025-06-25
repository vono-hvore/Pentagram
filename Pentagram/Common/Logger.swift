//
//  Logger.swift
//  PentagramExample
//
//  Created by Rodion Hladchenko on 25.06.2025.
//

@globalActor actor LoggerActor {
    static var shared: LoggerActor = .init()
}

@LoggerActor
final class Logger {
    private let rootLevel: Level
    
    init(_ level: Level = .info) {
        self.rootLevel = level
    }
    
    nonisolated func log(_ message: String, level: Level = .info) {
        Task { @LoggerActor in
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
