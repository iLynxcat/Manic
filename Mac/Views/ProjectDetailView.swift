import SwiftData
import SwiftUI

struct ProjectDetailView: View {
	var project: AbletonProject

	var nonBackupSets: [AbletonSet] {
		project.sets.filter { set in
			let path = set.path
			let backupIndex = path.pathComponents.lastIndex(of: "Backup")

			return backupIndex != (path.pathComponents.count - 2)
		}
	}

	var body: some View {
		ScrollView(.vertical) {
			VStack {
				GroupBox {
					ContentUnavailableView {
						Label(project.name, image: "ProjectFolder")
					}
					.listWidth()
				}
				.padding(.bottom)

				GroupBox {
					if project.sets.isEmpty {
						ContentUnavailableView {
							Image(systemName: "questionmark.folder")
						} description: {
							Text("This project has no Ableton sets")
						}
						.listWidth()
						.padding()
					} else {
						VStack(spacing: 0) {
							ForEach(nonBackupSets) { set in
								Button {
									openSet(set)
								} label: {
									HStack(alignment: .center) {
										VStack(alignment: .leading) {
											Text(set.name)
												.font(.body)
											Text(
												formatRelativeTime(
													set.modifiedAt)
											)
											.font(.caption)
											.foregroundStyle(.secondary)
										}
										Spacer()
										Text("Open")
											.foregroundStyle(.tertiary)
										Image(systemName: "chevron.right")
											.font(.caption)
											.foregroundStyle(.secondary)
									}
									.padding(.horizontal, 4)
									.padding(.vertical, 10)
								}
								.background(.clear)
								.buttonStyle(.plain)

								if set.id != nonBackupSets.last?.id {
									Divider()
										.padding(.horizontal, 6)
								}
							}
						}
						.listWidth()
						.padding(.vertical, -4)
						//					.groupBoxStyle(GroupBoxStyle)
					}
				} label: {
					Text("Live Sets")
						.font(.body)
						.fontWeight(.medium)
				}
			}
			.padding()
		}
		.background(.windowBackground)
	}

	private func openSet(_ set: AbletonSet) {
		let gotAccess = set.path
			.startAccessingSecurityScopedResource()
		guard gotAccess else {
			return
		}
		defer {
			set.path.stopAccessingSecurityScopedResource()
		}

		NSWorkspace.shared.open(set.path)
	}

	private var relativeDateFormatter: RelativeDateTimeFormatter {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full

		return formatter
	}

	private func formatRelativeTime(_ date: Date) -> String {
		return relativeDateFormatter.localizedString(
			for: date, relativeTo: .now)
	}
}

extension View {
	fileprivate func listWidth() -> some View {
		return
			self
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

	ProjectDetailView(project: project)
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

	ProjectDetailView(project: project)
		.modelContainer(container)
		.frame(
			minWidth: 256,
			idealWidth: 420,
			maxWidth: 590,
			minHeight: 100,
			maxHeight: .infinity
		)
}
