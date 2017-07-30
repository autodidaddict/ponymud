use "promises"
use "debug"

actor TheVoid is (Container & Examinable)
  let _contents: DefaultActorStorage

  new create() =>
    Debug.out("The void created")
    _contents = DefaultActorStorage

  be examine(p: Promise[ExaminationResult]) =>
    Debug.out("The void examined")    
    p(ExaminationResult("void", "The Void", "This is the void", _contents.allitems()))

  fun ref invstorage(): ActorStorage => _contents 

