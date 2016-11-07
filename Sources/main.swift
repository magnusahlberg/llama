import Kitura
import Foundation
import CommonMark

let router = Router()
let path = "posts/"

class Article {
	public let name: String
	public let path: String
	public let date: Date
	public let contents: String
	
	public init(name: String, path: String, date: Date, contents: String) {
		self.name = name
		self.path = path
		self.date = date
		self.contents = contents
	}
}
var articles = [Article]()
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-M-d"

func loadArticles() {
	guard let dirEnum = FileManager().enumerator(atPath: path) else { return }
	
	while let file = dirEnum.nextObject() as? String {
		guard file.hasSuffix("md") else { continue }
		
		let pathComponents = file.components(separatedBy: "/")
		guard pathComponents.count > 2 else { continue }
		guard let fileContents = try? String(contentsOfFile: path+file, encoding: String.Encoding.utf8) else { continue }
		
		guard let node = Node(markdown: fileContents) else { continue }
		
		let year = pathComponents[0]
		let month = pathComponents[1]
		let day = pathComponents[2]
		
		let dateString = year+"-"+month+"-"+day
		
		guard let articleDate = formatter.date(from: dateString) else { continue }
		
		let article = Article(name: file, path: path, date: articleDate, contents: node.html)
		articles.append(article)
	}
	articles.sort {
		$0.date > $1.date
	}
}

func render(page: String) -> String {
	guard let header = try? String(contentsOfFile: "templates/header.html", encoding: String.Encoding.utf8) else { return "" }
	guard let footer = try? String(contentsOfFile: "templates/footer.html", encoding: String.Encoding.utf8) else { return "" }

	return header+page+footer
}

func indexHandler(request: RouterRequest, response: RouterResponse, next: () -> Void) {
	if articles.count == 0 {
		loadArticles()
	}
	
	var body = ""
	
	for article in articles {
		body += article.contents
	}
	let page = render(page: body)
	do {
		try response.send(page).end()
	} catch {
		print("Could not send")
	}
}

loadArticles()
router.get("/", handler: indexHandler)
router.all("/assets", middleware: StaticFileServer(path: "./assets"))

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()
