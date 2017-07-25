trait CommandHandler
  be handle_verb(verb: String val, params: Array[String] val)

trait CommandHandlerMap 
  fun ref add(verb: String, handler: CommandHandler tag)
  fun ref remove(verb: String)?

trait CommandHandlerContainer
  be register_commandhandler(verb: String, handler: CommandHandler tag) =>
    commandhandlers().add(verb, handler)

  be unregister_commandhandler(verb: String) =>
    try
      commandhandlers().remove(verb)
    end

  fun ref commandhandlers() : CommandHandlerMap

