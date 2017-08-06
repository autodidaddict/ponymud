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
    let p = Promise[Array[String val
      ] val]
    _cm.who(p)
    p.next[None](recover this~_whofulfilled() end)

  be _whofulfilled(players: Array[String val] val) =>
    _parent.tell("\n==> Player Listing:\n")
    for name in players.values() do
        _parent.tell(name + "\n")
    end
    _parent.tell("\nThere are " + players.size().string() + " players connected.\n")    

  be identify(p: Promise[CommandHandlerMetadata]) =>
    p(CommandHandlerMetadata("who", "players"))