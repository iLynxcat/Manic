import SwiftUI
import SwiftData

struct SidebarProjectView: View {
	var project: AbletonProject
	
	private let timeFormatter: RelativeDateTimeFormatter
	
	init(showing project: AbletonProject) {
		self.project = project
		
		timeFormatter = RelativeDateTimeFormatter()
		timeFormatter.dateTimeStyle = .numeric
		timeFormatter.unitsStyle = .short
		timeFormatter.formattingContext = .listItem
	}
	
	var body: some View {
		HStack(alignment: .top, spacing: 6) {
			Image(systemName: "folder.fill")
				.font(.caption)
				.padding(.top, 3)
			
			VStack(alignment: .leading, spacing: 2) {
				Text(project.name.replacing(/\ Project$/, with: ""))
					.bold()
				
				Text(timeFormatter.localizedString(
					for: project.modifiedAt,
					relativeTo: .now))
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		}
		.padding(.vertical, 2)
	}
}

#Preview {
	@Previewable let demoProject = AbletonProject(
		name: "Floral Bounds Project",
		at: .homeDirectory
	)

	SidebarProjectView(showing: demoProject)
		.padding(.vertical, 4)
		.padding(.horizontal, 10)
		.background(.white)
		.modelContainer(for: AbletonProject.self, inMemory: true)
}
