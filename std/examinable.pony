use "promises"

class val ExaminationResult
  let name: String
  let short: String
  let long_description: String
  let contents: Array[Any tag] val

  new val create(name': String, short': String, long_description': String,
    contents': Array[Any tag] val) =>
    name = name'
    short = short'
    long_description = long_description'  
    contents = contents'

trait Examinable
  be examine(p: Promise[ExaminationResult])
