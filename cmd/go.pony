use "../server"
use "../std"

use "promises"
use "collections"

actor CmdGo is CommandHandler 
  let _parent: Player tag

  new create(parent: Player tag) =>
    _parent = parent
    
    _parent.register_commandhandler("go", this)

  be handle_verb(verb: String val, params: Array[String] val) =>
    try
      let p = Promise[Room tag]
      let dir = recover params(0)? end
      p.next[None](recover this~onparentroom(dir) end)
      _parent.environment(p)
    end      

  be onparentroom(dir: String val, room: Room tag) =>      
      let p = Promise[Array[Exit] val]
     
      p.next[None](recover this~_exitroom(dir) end)
      room.exits(p)

  be _exitroom(dir: String val, exits: Array[Exit] val) =>
    try 
      let e = exits(1)? // TODO pick the right exit from the list or report an error      
      _parent.move(e.destination())
      _parent.parsecommand("look")
    end

  be identify(p: Promise[CommandHandlerMetadata]) =>
    p(CommandHandlerMetadata("go", ""))