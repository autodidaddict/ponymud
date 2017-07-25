use "collections"

class DefaultCommandHandlerMap is CommandHandlerMap
  let _storage: Map[String, CommandHandler tag]
  
  new create() =>
    _storage = Map[String, CommandHandler tag]

  fun ref add(verb: String, handler: CommandHandler tag) =>
    _storage(verb) = handler 

  fun get(verb: String) : CommandHandler tag? =>    
    _storage(verb)
    

  fun ref remove(verb: String)? =>
    _storage.remove(verb)
