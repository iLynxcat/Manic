import Foundation
import SwiftData

#if DEBUG
@MainActor
let previewContainer: ModelContainer = {
	let schema = Schema([
		AbletonProject.self, AbletonSet.self
	])
	
	let config = ModelConfiguration(
		schema: schema,
		isStoredInMemoryOnly: true
	)
	
	return try! ModelContainer(for: schema, configurations: config)
}()

let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
typealias NamePair = (String, String)

func randomNamePair() -> NamePair {
	let adjectives = ["Floral", "Great", "Robust", "Exquisite", "Delicious"]
	let nouns = ["Bounds", "Escape", "Basket", "Contraption", "Concoction"]
	
	return (adjectives.randomElement()!, nouns.randomElement()!)
}

func generateDemoProject() -> AbletonProject {
	let namePair = randomNamePair()
	let name = "\(namePair.0) \(namePair.1)"
	
	return AbletonProject(
		name: name,
		at: .init(filePath: "/Users/me/Music/\(name)")
	)
}

func generateDemoSet(in project: AbletonProject) -> AbletonSet {
	let namePair: NamePair = {
		let freshPair = randomNamePair()
		let projectName = project.name.split(separator: " ")
		switch [0, 1].randomElement()! {
		case 0:
			return (freshPair.0, String(projectName[1]))
		case 1:
			return (String(projectName[0]), freshPair.1)
		default:
			fatalError("Invalid name mode")
		}
	}()
	let name = "\(namePair.0) \(namePair.1)"
	
	return project.insertSet(
		at: project.path.appending(path: "\(name).als"),
		name: name,
		modified: twoWeeksAgo
	)
}

func generateDemoBackupSet(in project: AbletonProject) -> AbletonSet {
	let namePair: NamePair = {
		let freshPair = randomNamePair()
		let projectName = project.name.split(separator: " ")
		switch [0, 1].randomElement()! {
		case 0:
			return (freshPair.0, String(projectName[1]))
		case 1:
			return (String(projectName[0]), freshPair.1)
		default:
			fatalError("Invalid name mode")
		}
	}()
	let name = "\(namePair.0) \(namePair.1)"
	
	return project.insertSet(
		at: project.path.appending(components: "Backup", "\(name) [0000-00-00 000000].als"),
		name: name,
		modified: twoWeeksAgo
	)
}
#endif
