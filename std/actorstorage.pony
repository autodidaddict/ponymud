trait ActorStorage 
  fun ref add(o: Any tag)
  fun ref remove(o: Any tag)
  fun allitems() : Array[Any tag] val
  

class DefaultActorStorage is ActorStorage
  let _storage: Array[Any tag]

  new create() =>
    _storage = Array[Any tag]

  fun ref add(o: Any tag) =>
    _storage.push(o)

  fun ref remove(o: Any tag) =>
    try
      let idx = _storage.find(o)?
      _storage.delete(idx)?
    end 

  fun allitems(): Array[Any tag] val =>
    let d: Array[Any tag] trn = recover trn Array[Any tag] end
    for obj in _storage.values() do 
      d.push(obj)
    end 
    consume d 