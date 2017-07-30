use "files"

primitive ResourceReader
  fun read_resource(path: FilePath, resource: String) : String =>
    try 
      let newPath = FilePath(path, resource)?
      let file = OpenFile(newPath) as File
      file.read_string(file.size())
    else
      "(resource not found)\n"
    end