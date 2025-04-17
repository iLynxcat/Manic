import Foundation
import SwiftData

@Model
final class AbletonProject {
	var id: UUID
	@Attribute(.unique)
	var path: URL

	var name: String

	@Relationship(deleteRule: .cascade, inverse: \AbletonSet.project)
	var sets = [AbletonSet]()
	var backupSets: [AbletonSet] {
		sets.filter({ set in
			set.path.deletingLastPathComponent().lastPathComponent == "Backup"
		})
	}
	var nonBackupSets: [AbletonSet] {
		sets.filter({ set in
			set.path.deletingLastPathComponent().lastPathComponent != "Backup"
		})
	}

	var modifiedAt: Date {
		self.sets
			.map { $0.modifiedAt }
			.sorted(by: { $0.compare($1) == .orderedDescending })
			.first ?? Date.distantPast
	}

	init(id: UUID = UUID(), name: String, at path: URL) {
		self.id = id
		self.name = name
		self.path = path
	}
}

extension AbletonProject {
	func insertSet(at path: URL, name: String, modified modifiedAt: Date)
		-> AbletonSet
	{
		let newSet = AbletonSet(
			in: self, at: path, name: name, modified: modifiedAt)
		self.sets.append(newSet)
		return newSet
	}
}
