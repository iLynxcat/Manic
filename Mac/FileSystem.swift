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
				print("Project candidate: \(child.lastPathComponent)")
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
			includingPropertiesForKeys: [.isRegularFileKey, .contentModificationDateKey]
		)
		
		var discoveredAls: [URL] = []
		
		for child in children {
			if child.hasAlsExtension && child.isFile {
				discoveredAls.append(child)
				print("ALS discovered: \(child.lastPathComponent)")
				continue
			} else if child.isDirectory {
				discoveredAls += scanAlsRecursively(in: child)
				continue
			}
		}
		
		return discoveredAls
	}
}

private extension URL {
	var terminatesWithProjectLiterally: Bool {
		return printing(
			"\(self.lastPathComponent).terminatesWithProjectLiterally=",
			self.lastPathComponent.wholeMatch(of: /.+\ Project$/) != nil
		)
	}
	
	var hasAlsExtension: Bool {
		return printing("\(self.lastPathComponent).hasAlsExtension=", self.pathExtension == "als")
	}
}

extension URL {
	var baseName: String {
		self.deletingPathExtension().lastPathComponent
	}
	
	var isDirectory: Bool {
		let isDir = (try? self.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
		return printing("\(self.lastPathComponent).isDir=", isDir)
	}
	
	var isFile: Bool {
		let isFile = (try? self.resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile == true
		return printing("\(self.lastPathComponent).isFile=", isFile)
	}
	
	var modificationDate: Date {
		let modDate = (try? self.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
		return printing("\(self.lastPathComponent).modificationDate=", modDate)
	}
}
