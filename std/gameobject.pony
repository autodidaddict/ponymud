use "promises"

trait GameObject
  be environment(p: Promise[Room tag]) =>
    p(location())

  be move_force(to: Room tag) =>
    set_location(to)    

  fun location(): Room tag
  fun ref set_location(loc: Room tag)