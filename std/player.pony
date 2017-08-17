use "net"
use "promises"
use "files"
use "debug"

use "../server"
use "../cmd"

trait TerminalConnected
  be tell(msg: String)

actor Player is (Container & Combatant & CommandHandlerContainer & TerminalConnected & GameObject)
    let _out: OutStream
    let _conn: TCPConnection tag 
    let _cm: ConnectionManager tag 
    var _pname: (String | None) = None 
    let _container: DefaultActorStorage
    let _cmdmap: DefaultCommandHandlerMap
    let _respath: FilePath 
    var _currentloc: Room tag

    new create(init_loc: Room tag, cm: ConnectionManager tag, conn: TCPConnection tag, out:OutStream, resourcepath: FilePath) =>
        Debug.out("Player created")
        _cm = cm 
        _conn = conn   
        _out = out     
        _respath = resourcepath
        _cmdmap = DefaultCommandHandlerMap 
        _container = DefaultActorStorage 
        _currentloc = init_loc

        //_currentloc.enter_inv(this, _currentloc)
        move(_currentloc)

        _conn.write(ResourceReader.read_resource(_respath, "motd.txt"))
        initcommands()

    be tell(msg: String) =>
        _conn.write(msg) 

    be gathername(p: Promise[String]) =>
        p(_name())     
    
    be parsecommand(cmd: String) =>
        if _pname is None then
            _pname = cmd
            _conn.write("Welcome back to PonyMUD, " + _name() + "!\n")                 
            emitall("has logged in.\n")    
            return       
        end 

        let parts: Array[String val] val = cmd.split_by(" ")
        try
            let verb = parts(0)?
            let remainder = recover val parts.slice(1, parts.size()) end
            let ch = _cmdmap.get(verb)?
            ch.handle_verb(verb, remainder) 
        else  
            this.tell("Unknown Command.\n")
        end           
        
    be emitall(text: String) =>
        _cm.broadcast(this, _name() + " " + text)

    fun ref invstorage(): ActorStorage => _container 

    be enumerate_commands(ip: CollectionReceiver[CommandHandlerMetadata] tag) =>
        let cmds: Array[CommandHandler tag] = commandhandlers().allcommands() 
        let collector: Collector[CommandHandlerMetadata] = Collector[CommandHandlerMetadata](cmds.size(), ip)

        for cmd in cmds.values() do
          let p = Promise[CommandHandlerMetadata]
          p.next[None](recover collector~receive() end)
          cmd.identify(p)
        end 

    fun ref commandhandlers(): CommandHandlerMap => _cmdmap 

    be attacked_by(ob: Any tag) =>
        _out.print("Got attacked")

    fun ref initcommands() =>
        CmdWho(this, _cm)
        CmdList(this)
        CmdExamine(this)
        CmdGo(this)
        
    fun _name(): String =>
        match _pname
        | let n: String => n
        else
            "Someone"
        end 

    fun location(): Room tag =>
        _currentloc 

    fun ref set_location(loc: Room tag) =>
        _currentloc = loc

