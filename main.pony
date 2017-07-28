use "net"
use "files"

use "./server"

actor Main
  new create(env: Env) =>    
    try
      let resource_path = FilePath(env.root as AmbientAuth, "./res")?
      let cm = ConnectionManager(env.out, resource_path)
      TCPListener(env.root as AmbientAuth, Listener(env.out, cm))
    else
      env.out.print("Cannot start server.")
    end

