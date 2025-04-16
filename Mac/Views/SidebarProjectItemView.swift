import SwiftData
import SwiftUI

struct SidebarProjectItemView: View {
	var project: AbletonProject

	private var formattedTime: String

	init(showing project: AbletonProject) {
		self.project = project

		let timeFormatter = RelativeDateTimeFormatter()
		timeFormatter.dateTimeStyle = .numeric
		timeFormatter.unitsStyle = .short
		timeFormatter.formattingContext = .listItem

		formattedTime = timeFormatter.localizedString(
			for: project.modifiedAt,
			relativeTo: .now)

	}

	var body: some View {
		let quickStats = [formattedTime, "\(project.sets.count) sets"]

		HStack(alignment: .top, spacing: 6) {
			Image(systemName: "folder.fill")
				.font(.caption)
				.foregroundStyle(.secondary)
				.padding(.top, 3.5)

			VStack(alignment: .leading, spacing: 2) {
				Text(project.name)
					.bold()

				Text(quickStats.joined(separator: " • "))
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		}
	}
}

#Preview {
	let container = previewContainer
	let project = generateDemoProject()

	do {
		let _ = container.mainContext.insert(project)
	}

	SidebarProjectItemView(showing: project)
		.padding(4)
		.background(.white)
		.modelContainer(container)
}
