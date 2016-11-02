// import Kitura
import Foundation

// let router = Router()
let path = "posts/"
let dirEnum = FileManager().enumerator(atPath: path)
var articles = [String: String]()
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-M-d"

if dirEnum != nil {
	while let file = dirEnum!.nextObject() as? String {
		if file.hasSuffix("md") {
			print("File: \(file)")
			let pathComponents = file.components(separatedBy: "/")
			if pathComponents.count > 2 {
				let dateString = pathComponents[0]+"-"+pathComponents[1]+"-"+pathComponents[2]
				let articleDate = formatter.date(from: dateString)
				print("File: \(file), Date: \(articleDate)")
			}
			if let fileContents = try? String(contentsOfFile: path+file, encoding: String.Encoding.utf8) {
				articles[file] = fileContents
			}
		}
	}
}
    
/* router.get("/") {
	request, response, next in
    response.send("temp")
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()
*/