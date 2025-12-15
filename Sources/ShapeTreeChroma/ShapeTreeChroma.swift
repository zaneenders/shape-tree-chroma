import Configuration
import Logging
import ShapeTreeShared
import Wayland

@main
@MainActor
struct ShapeTreeChroma {
  static func main() async {
    let logger = Logger.tracing(label: #function)
    let configReader = await loadConfig(logger: logger)
    guard let name = configReader.string(forKey: "NAME") else {
      logger.critical("No NAME laoded")
      return
    }
    guard let password = configReader.string(forKey: "PASSWORD") else {
      logger.critical("No PASSWORD laoded")
      return
    }
    let client = ShapeTreeClient()

    var entries: [Entry] = []
    do {
      try await client.login(name: name, password: password)
      entries = try await client.getEntries(Day.today)
      for entry in entries {
        logger.trace("\(entry.content)")
      }
    } catch {
      logger.error("\(error)")
      return
    }

    Wayland.setup()
    event_loop: for await ev in Wayland.events() {
      switch ev {
      case .frame(let winH, let winW):
        let screen = Window(o: .vertical, words: entries.map { $0.content })
        Wayland.drawFrame((height: winH, width: winW), screen)
      case .key(let code, let keyState):
        switch (code, keyState) {
        case (1, _):
          Wayland.exit()
        case (34, 1):
          Task {
            logger.trace("34")
            let entry = CreateEntryRequest(content: "New entry \(entries.count)")
            logger.trace("sending entry: \(entry)")
            try await client.createEntry(entry)
            logger.trace("entry: \(entry) created")
            entries = try await client.getEntries(Day.today)
            logger.trace("entries updated")
          }
        case (_, 1):
          logger.trace("code: \(code), keyState: \(keyState)")
          Task {
            entries = try await client.getEntries(Day.today)
          }
        case (_, _):
          ()
        }
      }
    }

    switch Wayland.state {
    case .error(let reason):
      print("error: \(reason)")
    case .running, .exit:
      ()
    }
  }
}
