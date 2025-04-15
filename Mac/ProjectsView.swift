import SwiftData
import SwiftUI

private let fileManager = FileManager.default

struct ProjectsView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var projects: [AbletonProject]

	var sortedProjects: [AbletonProject] {
		projects.sorted {
			$0.modifiedAt.compare($1.modifiedAt) == .orderedDescending
		}
	}

	@State private var presentFolderChooser = false
	@State private var selectedProject: AbletonProject? = nil
	
	private var fileScanner = FileScanner()

	var body: some View {
		NavigationSplitView(
			columnVisibility: .constant(.all)
		) {
			List(sortedProjects, selection: $selectedProject) { project in
				NavigationLink {
					ProjectOverviewView(project: project)
						.navigationTitle(project.name)
				} label: {
					SidebarProjectView(showing: project)
				}
			}
			.toolbar {
				ToolbarItem {
					Button {
						presentFolderChooser = true
					} label: {
						Label("Add Folder", systemImage: "folder.badge.plus")
					}
				}
			}
		} detail: {
			// todo: some fancy logo ident/welcome screen here
			Text("No project selected")
		}
		.fileImporter(
			isPresented: $presentFolderChooser,
			allowedContentTypes: [.folder],
			allowsMultipleSelection: true,
			onCompletion: addScanPath
		)
		.navigationTitle("Projects")
	}

	private func addScanPath(_ result: Result<[URL], any Error>) {
		presentFolderChooser = false

		switch result {
		case .success(let folders):
			for folder in folders {
				let didGetAccess =
					folder.startAccessingSecurityScopedResource()
				guard didGetAccess else {
					return
				}
				defer {
					folder.stopAccessingSecurityScopedResource()
				}

				// TODO: store and track the chosen folder(s) -- as of now we only scan them the one time

				withAnimation(.spring) {
					// 1. parse for whether each children are ableton project
					// TODO: later check if provided folder matches too, users may want to just add one project
					for projectPath in fileScanner.scanProjectsRecursively(
						in: folder)
					{
						let alsFiles = fileScanner
							.scanAlsRecursively(in: projectPath)

						guard !alsFiles.isEmpty else {
							continue
						}

						let project = AbletonProject(
							name:
								projectPath
								.deletingPathExtension()
								.lastPathComponent
								.replacing(/\ Project$/, with: ""),
							at: projectPath)
						modelContext.insert(project)

						alsFiles.map { file in
							AbletonSet(
								in: project,
								at: file,
								name: file.baseName,
								modified: file.modificationDate
							)
						}.forEach { set in
							modelContext.insert(set)
							project.sets.append(set)
						}
					}
					
					try! modelContext.save()
				}
			}
		case .failure(let error):
			fatalError(
				"Crashed during onCompletion handler for importing new folders to scan: \(error)"
			)
		}
	}

	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			for _ in offsets {
				// todo: delete these projects from filesystem (or mark ignored?)
			}
		}
	}
}

#Preview {
	ProjectsView()
		.modelContainer(for: AbletonProject.self, inMemory: true)
}
