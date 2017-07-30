use "../server"
use "../std"

use "collections"
use "promises"

type _CmdParent is (TerminalConnected tag & CommandHandlerContainer tag)

actor CmdList is CommandHandler 
  let _parent: _CmdParent tag
  
  new create(parent: _CmdParent tag) =>
    _parent = parent
  
    _parent.register_commandhandler("cmds", this)
    _parent.register_commandhandler("commands", this)
  
  be handle_verb(verb: String val, params: Array[String] val) =>
    _parent.enumerate_commands(this)    

  be identify(p: Promise[CommandHandlerMetadata]) =>
    p(CommandHandlerMetadata("cmds", "commands"))

  be receivecollection(coll: Array[CommandHandlerMetadata] val) =>
    let m = Map[String, CommandHandlerMetadata]
    for cmd in coll.values() do
      m(cmd.name) = cmd 
    end    
    // TODO - make this into columnar list
    // 
    _parent.tell("You have access to the following commands:\n\n")
    for c in m.values() do
      _parent.tell(c.name + " (" + c.aliases + ")\n")
    end 
    
    