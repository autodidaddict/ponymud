use "net"
use "files"
use "collections"
use "promises"
use "../core"

actor ConnectionManager
  let _out: OutStream 
  let _respath: FilePath
  let _players: MapIs[TCPConnection, Player]  
  
  new create(out: OutStream, respath: FilePath) =>
    _players = MapIs[TCPConnection, Player]
    _respath = respath 

    _out = out 
    _out.print("connection manager created")

  be accepted(conn: TCPConnection tag) =>
    _out.print("[CM] Connection accepted.")
    let v = TheVoid.create()
    let p = Player(v, this, conn, _out, _respath)
    _players(conn) = p    

  be dowho(requester: Player tag) =>
    let collector: Collector[String] = Collector[String](_players.size(), requester)
    for player in _players.values() do
      let p = Promise[String]
      p.next[None](recover collector~receive() end)
      player.gathername(p)
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
