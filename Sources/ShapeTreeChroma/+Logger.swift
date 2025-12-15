import Logging

extension Logger {
  static func tracing(label: String) -> Logger {
    var logger = Logger(label: label)
    logger.logLevel = .trace
    return logger
  }
}
