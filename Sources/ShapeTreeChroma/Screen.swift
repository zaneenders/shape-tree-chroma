import Wayland

struct Window: Block {
  let name: String
  let o: Orientation
  let words: [String]
  var layer: some Block {
    Group(o) {
      Word("Welcome: \(name)").scale(4)
      for word in words {
        Word(word).scale(2)
      }
    }
  }
}
