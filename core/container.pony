trait Container
  be enter_inv(ob: Any tag, from: Any tag) =>
    invstorage().add(ob)

  be leave_inv(ob: Any tag, to: Any tag) =>
    invstorage().remove(ob)

  fun ref invstorage() : ActorStorage

trait Combatant
  be attacked_by(ob: Any tag)