use "promises"

class val ExaminationResult
  let name: String
  let short: String
  let long_description: String

  new val create(name': String, short': String, long_description': String) =>
    name = name'
    short = short'
    long_description = long_description'

trait Examinable
  be examine(p: Promise[ExaminationResult])
