//type Room is (Container tag & Examinable tag)
use "promises"

trait Room is (Container & Examinable)
  be exits(p: Promise[Array[Exit] val])

class val Exit
  let _direction: String val
  let _destination: Room tag 

  new create(direction': String val, destination': Room tag) =>
    _direction = direction'
    _destination = destination'

  fun destination(): Room tag =>
    _destination 

  fun direction(): String val =>
    _direction
