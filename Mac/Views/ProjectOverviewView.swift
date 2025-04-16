import SwiftData
import SwiftUI

struct ProjectOverviewView: View {
	var project: AbletonProject

	var body: some View {
		ScrollView(.vertical) {
			GroupBox {
				if project.sets.isEmpty {
					ContentUnavailableView {
						Label("No Sets", systemImage: "questionmark.folder")
					} description: {
						Text("This project has no Ableton sets")
					}
					.listWidth()
					.padding()
				} else {
					VStack(spacing: 0) {
						ForEach(project.sets.filter { set in
							let path = set.path
							let backupIndex = path.pathComponents.lastIndex(of: "Backup")
							
							return backupIndex != (path.pathComponents.count - 1)
						}) { set in
							Button {
								// Open the set file (later implementation)
							} label: {
								HStack {
									VStack(alignment: .leading) {
										Text(set.name)
											.font(.body)
										Text(set.modifiedAt, style: .date)
											.foregroundStyle(.secondary)
											.font(.caption)
									}
									Spacer()
									Image(systemName: "arrow.right.circle")
										.foregroundStyle(.secondary)
								}
								.contentShape(Rectangle())
								.padding(.vertical, 6)
								.padding(.horizontal, 4)
							}
							.buttonStyle(.plain)
							
							if set.id != project.sets.last?.id {
								Divider()
							}
						}
					}
					.listWidth()
					.padding(.vertical, 4)
				}
			} label: {
				Label("Sets", systemImage: "document.fill")
			}
			.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
		}
		.background(.windowBackground)
	}
}

private extension View {
	func listWidth() -> some View {
		return self
			.frame(minWidth: 320, idealWidth: 420, maxWidth: 512)
	}
}

#Preview("Overview (With Sets)") {
	let container = previewContainer
	let project = generateDemoProject()
	let sets = [
		generateDemoSet(in: project),
		generateDemoSet(in: project),
		generateDemoSet(in: project),
	]

	do {
		let _ = sets.forEach(container.mainContext.insert)
		let _ = container.mainContext.insert(project)
	}

	ProjectOverviewView(project: project)
		.modelContainer(container)
		.frame(
			minWidth: 256,
			idealWidth: 420,
			maxWidth: 590,
			minHeight: 100,
			maxHeight: .infinity
		)
}

#Preview("Overview (No Sets)") {
	let container = previewContainer
	let project = generateDemoProject()
	
	do {
		let _ = container.mainContext.insert(project)
	}

	ProjectOverviewView(project: project)
		.modelContainer(container)
		.frame(
			minWidth: 256,
			idealWidth: 420,
			maxWidth: 590,
			minHeight: 100,
			maxHeight: .infinity
		)
}
