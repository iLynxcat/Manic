import Foundation
import SwiftData

@Model
final class AbletonSet: Identifiable {
	var id: UUID
	@Attribute(.unique)
	var path: URL
	
	var name: String
	var modifiedAt: Date
	
	@Relationship var project: AbletonProject
	
	init(
		id: UUID = UUID(),
		in project: AbletonProject,
		at path: URL,
		name: String,
		modified modifiedAt: Date
	) {
		self.id = id
		self.name = name
		self.path = path
		self.modifiedAt = modifiedAt
		self.project = project
	}
}
