use "net"
use "promises"
use "../server"
use "../cmd"

actor Player is (Container & Combatant & CommandHandlerContainer)
    let _out: OutStream
    let _conn: TCPConnection tag 
    let _cm: ConnectionManager tag 
    var _pname: (String | None) = None 
    let _container: DefaultActorStorage
    let _cmdmap: DefaultCommandHandlerMap

    new create(cm: ConnectionManager tag, conn: TCPConnection tag, out:OutStream) =>
        _cm = cm 
        _conn = conn   
        _out = out     
        _cmdmap = DefaultCommandHandlerMap 
        _container = DefaultActorStorage 
        initcommands()

    be tell(msg: String) =>
        _conn.write(msg) 

    be gathername(p: Promise[String]) =>
        p(_name())

    be receivecollection(coll: Array[String] val) =>
        _conn.write("\n==> Player Listing:\n")
        for name in coll.values() do
            _conn.write(name + "\n")
        end
        _conn.write("\nThere are " + coll.size().string() + " players connected.\n")
    
    be parsecommand(cmd: String) =>
        if _pname is None then
            _pname = cmd
            _conn.write("You've chosen a name.\n")                 
            emitall("has logged in.\n")    
            return
        else 
            //_conn.write("[Debug] You typed " + cmd + ".\n" )
            emitall("typed '" + cmd + "'\n")
        end 
        let parts = cmd.split_by(" ")
        try
            let ch = _cmdmap.get(parts(0))
            ch.handle_verb(parts(0), recover Array[String] end) // TODO send the other parts
        else  
            this.tell("Unknown Command.\n")
        end
        /*if cmd == "who" then
            //_cm.dowho(this) 
            try 
                let ch = _cmdmap.get("who")
                ch.handle_verb("who", recover Array[String] end)
            end                        
        end */

    be emitall(text: String) =>
        _cm.broadcast(_name() + " " + text)

    fun ref invstorage(): ActorStorage => _container 

    fun ref commandhandlers(): CommandHandlerMap => _cmdmap 

    be attacked_by(ob: Any tag) =>
        _out.print("Got attacked")

    fun ref initcommands() =>
        CmdWho(this, _cm)
        
    fun _name(): String =>
        match _pname
        | let n: String => n
        else
            "Someone"
        end 

