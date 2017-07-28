use "promises"

use "../core"

class val CommandHandlerMetadata
  let name : String
  let aliases: String

  new val create(name': String, aliases': String) =>
    name = name'
    aliases = aliases'

trait CommandHandler
  be handle_verb(verb: String val, params: Array[String] val)
  be identify(p: Promise[CommandHandlerMetadata])

trait CommandHandlerMap 
  fun ref add(verb: String, handler: CommandHandler tag)
  fun ref remove(verb: String)?
  fun allcommands() : Array[CommandHandler tag]

trait CommandHandlerContainer
  be register_commandhandler(verb: String, handler: CommandHandler tag) =>
    commandhandlers().add(verb, handler)

  be unregister_commandhandler(verb: String) =>
    try
      commandhandlers().remove(verb)?
    end

  be enumerate_commands(ip:  CollectionReceiver[CommandHandlerMetadata val] tag)   

  fun ref commandhandlers() : CommandHandlerMap

