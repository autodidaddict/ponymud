//type Room is (Container tag & Examinable tag)
use "promises"

trait Room is (Container & Examinable)
  be exits(p: Promise[Array[Exit] val])

class val Exit
  let _directions: Array[String] val
  let _destination: Room tag 

  new create(directions': Array[String] val, destination': Room tag) =>
    _directions = directions'
    _destination = destination'

  fun destination(): Room tag =>
    _destination 

  fun directions(): Array[String] val =>
    _directions
