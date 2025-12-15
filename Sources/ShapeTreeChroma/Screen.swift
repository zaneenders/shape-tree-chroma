import Wayland

struct Window: Block {
  let o: Orientation
  let words: [String]
  var layer: some Block {
    Group(o) {
      for word in words {
        Word(word).scale(4)
      }
    }
  }
}
