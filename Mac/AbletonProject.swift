import Foundation
import SwiftData

@Model
final class AbletonProject {
	var id = UUID()
	
	var name: String
	var path: URL
	
	@Relationship(deleteRule: .cascade, inverse: \AbletonSet.project)
	var sets = [AbletonSet]()
	
	var modifiedAt: Date {
		self.sets
			.map { $0.modifiedAt }
			.sorted(by: { $0.compare($1) == .orderedDescending })
			.first ?? Date.distantPast
	}
	
	init(name: String, at path: URL) {
		self.name = name
		self.path = path
    }
}

@Model
final class AbletonSet {
	var id = UUID()
	
	var name: String
	var path: URL
	var modifiedAt: Date
	
	@Relationship var project: AbletonProject
	
	init(in project: AbletonProject, at path: URL, name: String, modified modifiedAt: Date) {
		self.name = name
		self.path = path
		self.modifiedAt = modifiedAt
		self.project = project
	}
}
