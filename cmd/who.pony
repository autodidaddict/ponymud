use "../server"
use "../std"

use "promises"

actor CmdWho is CommandHandler 
  let _parent: Player tag
  let _cm: ConnectionManager tag 

  new create(parent: Player tag, cm: ConnectionManager tag) =>
    _parent = parent
    _cm = cm 
    _parent.register_commandhandler("who", this)
    _parent.register_commandhandler("players", this)

  be handle_verb(verb: String val, params: Array[String] val) =>
    _cm.dowho(_parent)

  be identify(p: Promise[CommandHandlerMetadata]) =>
    p(CommandHandlerMetadata("who", "players"))