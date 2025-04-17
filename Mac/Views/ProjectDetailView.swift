import SwiftData
import SwiftUI

struct ProjectDetailView: View {
	var project: AbletonProject

	var body: some View {
		ScrollView(.vertical) {
			VStack {
				GroupBox {
					ProjectDetailHeaderView(project: project)
						.padding(.horizontal, 16)
						.padding(.vertical, 52)
						.listWidth()
				}
				.padding(.bottom)

				GroupBox {
					if project.nonBackupSets.isEmpty {
						ContentUnavailableView {
							Image(systemName: "questionmark.folder")
						} description: {
							Text("This project has no Ableton sets")
						}
						.listWidth()
						.padding()
					} else {
						VStack(spacing: 0) {
							ForEach(project.nonBackupSets) { set in
								AlsFileItem(set: set)

								if set.id != project.nonBackupSets.last?.id {
									Divider()
										.padding(.horizontal, 6)
								}
							}
						}
						.listWidth()
						.padding(.vertical, -4)
					}
				} label: {
					Text("Live Sets")
						.font(.body)
						.fontWeight(.medium)
						.padding(.bottom, 6)
				}

				if !project.backupSets.isEmpty {
					GroupBox {
						VStack(spacing: 0) {
							ForEach(project.backupSets) { set in
								AlsFileItem(set: set)

								if set.id != project.backupSets.last?.id {
									Divider()
										.padding(.horizontal, 6)
								}
							}
						}
						.listWidth()
						.padding(.vertical, -4)
					} label: {
						Text("Backups")
							.font(.body)
							.fontWeight(.medium)
							.padding(.vertical, 6)
					}
				}
			}
			.padding()
		}
		.toolbarTitleMenu(content: {
			Text("Heyyyy")
			Button {
			} label: {
				Text("Hiii!")
			}
		})
		.background(.windowBackground)
	}
}

private struct AlsFileItem: View {
	let set: AbletonSet

	var body: some View {
		Button {
			openSet(set)
		} label: {
			HStack(alignment: .center) {
				Image("ALSFileSmall")
					.padding(.horizontal, -4)

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

				Image(systemName: "arrow.right.circle")
					.font(.body)
					.foregroundStyle(.secondary)
			}
			.padding(.horizontal, 4)
			.padding(.vertical, 10)
			.overlay(.primary.opacity(0.00001))
		}
		.buttonStyle(.plain)
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

	private func openProjectFolder(_ project: AbletonProject) {
		let gotAccess = project.path
			.startAccessingSecurityScopedResource()
		guard gotAccess else {
			return
		}
		defer {
			project.path.stopAccessingSecurityScopedResource()
		}

		NSWorkspace.shared.open(project.path)
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

#if DEBUG
	#Preview("Overview (With Sets)") {
		let container = previewContainer
		let project = generateDemoProject()
		let sets = [
			generateDemoSet(in: project),
			generateDemoSet(in: project),
			generateDemoBackupSet(in: project),
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
#endif
