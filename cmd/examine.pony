use "../server"
use "../std"

use "promises"

actor CmdExamine is CommandHandler 
  let _parent: Player tag

  new create(parent: Player tag) =>
    _parent = parent
    
    _parent.register_commandhandler("look", this)
    _parent.register_commandhandler("examine", this)

  be handle_verb(verb: String val, params: Array[String] val) =>
    if params.size() > 0 then
      _parent.tell("We don't yet support examining individual objects.\n")
    else
      let p = Promise[Room tag]
      p.next[None](recover this~exroom() end)
      _parent.environment(p)
    end

  be exroom(room: Room tag) =>
    let p = Promise[ExaminationResult]
    p.next[None](recover this~displayexresult() end)
    room.examine(p)

  be displayexresult(er: ExaminationResult) =>
     _parent.tell(er.short + "\n" + er.long_description + "\n")
     _parent.tell("There are " + er.contents.size().string() + " objects here.\n")

  be identify(p: Promise[CommandHandlerMetadata]) =>
    p(CommandHandlerMetadata("look", "examine"))