import Foundation

struct FileScanner {
	private let fileManager = FileManager.default

	func scanProjectsRecursively(in path: URL) -> [URL] {
		let url = path.absoluteURL

		let children = try! fileManager.contentsOfDirectory(
			at: url,
			includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey]
		)

		var projects: [URL] = []

		for child in children {
			if child.terminatesWithProjectLiterally && child.isDirectory {
				projects.append(child)
				continue
			} else if child.isDirectory {
				projects += scanProjectsRecursively(in: child)
				continue
			}
		}

		return projects
	}

	func scanAlsRecursively(in path: URL) -> [URL] {
		let url = path.absoluteURL
		let children = try! fileManager.contentsOfDirectory(
			at: url,
			includingPropertiesForKeys: [
				.isRegularFileKey, .contentModificationDateKey,
			]
		)

		var discoveredAls: [URL] = []

		for child in children {
			if child.hasAlsExtension && child.isFile {
				discoveredAls.append(child)
				continue
			} else if child.isDirectory {
				discoveredAls += scanAlsRecursively(in: child)
				continue
			}
		}

		return discoveredAls
	}
}

extension URL {
	fileprivate var terminatesWithProjectLiterally: Bool {
		return self.lastPathComponent.wholeMatch(of: /.+\ Project$/) != nil
	}

	fileprivate var hasAlsExtension: Bool {
		return self.pathExtension == "als"
	}
}

extension URL {
	var baseName: String {
		self.deletingPathExtension().lastPathComponent
	}

	var isDirectory: Bool {
		return (try? self.resourceValues(forKeys: [.isDirectoryKey]))?
			.isDirectory == true
	}

	var isFile: Bool {
		return (try? self.resourceValues(forKeys: [.isRegularFileKey]))?
			.isRegularFile == true
	}

	var modificationDate: Date {
		return
			(try? self.resourceValues(forKeys: [.contentModificationDateKey]))?
			.contentModificationDate ?? Date.distantPast
	}
}
