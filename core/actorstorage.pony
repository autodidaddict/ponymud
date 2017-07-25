trait ActorStorage 
  fun ref add(o: Any tag)

  fun ref remove(o: Any tag)


class DefaultActorStorage is ActorStorage
  let _storage: Array[Any tag]

  new create() =>
    _storage = Array[Any tag]

  fun ref add(o: Any tag) =>
    _storage.push(o)

  fun ref remove(o: Any tag) =>
    try
      let idx = _storage.find(o)
      _storage.delete(idx)
    end 