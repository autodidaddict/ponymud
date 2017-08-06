
use "net"
use "files"
use "collections"
use "promises"
use "../std"

actor ConnectionManager
  let _out: OutStream 
  let _respath: FilePath
  let _players: MapIs[TCPConnection, Player]  
  let _theVoid: Room tag
  
  new create(out: OutStream, respath: FilePath) =>
    _players = MapIs[TCPConnection, Player]
    _respath = respath 
    _theVoid = TheVoid 
    _out = out 
    _out.print("connection manager created")

  be accepted(conn: TCPConnection tag) =>
    _out.print("[CM] Connection accepted.")
    
    let p = Player(_theVoid, this, conn, _out, _respath)
    _players(conn) = p    

  be who(p: Promise[Array[String val] val]) =>
    let names: Array[Promise[String]] = Array[Promise[String]]
    for player in _players.values() do
      let pname = Promise[String]
      player.gathername(pname)
      names.push(pname)
    end 
    try 
      let first = names(0)?
      let remainder: Array[Promise[String]] = names.slice(1, names.size()) 
      let joined: Promise[Array[String val] val] = first.join(remainder.values())
      joined.next[None](recover p~apply() end)
    end

  be closed(conn: TCPConnection tag) =>
    try      
      _players.remove(conn)?
    end
    _out.print("[CM] Connection closed.")

  be cmdreceived(conn: TCPConnection, cmd: String) =>
    _out.print("[CM] received command text.")
    try 
        _players(conn)?.parsecommand(cmd)
    end 

  be broadcast(source: Player, msg: String) =>
    _bcast(source, msg)

  fun _bcast(source: Player, msg: String) =>
    for player in _players.values() do
        if not (player is source) then
          player.tell(msg)
        end
    end
