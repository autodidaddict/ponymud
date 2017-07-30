use "../server"
use "../core"

use "promises"

actor CmdExamine is CommandHandler 
  let _parent: Player tag

  new create(parent: Player tag) =>
    _parent = parent
    
    _parent.register_commandhandler("look", this)
    _parent.register_commandhandler("examine", this)

  be handle_verb(verb: String val, params: Array[String] val) =>
    let p = Promise[Room tag]
    p.next[None](recover this~exroom() end)
    _parent.environment(p)

  be exroom(room: Room tag) =>
    let p = Promise[ExaminationResult]
    p.next[None](recover this~displayexresult() end)
    room.examine(p)

  be displayexresult(er: ExaminationResult) =>
     _parent.tell(er.short + "\n" + er.long_description + "\n")

  be identify(p: Promise[CommandHandlerMetadata]) =>
    p(CommandHandlerMetadata("look", "examine"))