use "promises"
use "debug"

use "../cmd"

actor TheVoid is Room 
  let _contents: DefaultActorStorage
  var _exits: Array[Exit] val

  new create() =>
    Debug.out("The void created")
    _contents = DefaultActorStorage
    _exits = recover Array[Exit] end 
    _exits = recover val
      let e = Array[Exit]
      e.push(recover Exit("west", this) end)
      e.push(recover Exit("east", this) end)
      e 
    end

  be examine(p: Promise[ExaminationResult]) =>
    Debug.out("The void examined")    
    p(ExaminationResult("void", "The Void", "This is the void", _contents.allitems()))

  be exits(p: Promise[Array[Exit] val]) =>
    p(_exits)

  fun ref invstorage(): ActorStorage => _contents 

