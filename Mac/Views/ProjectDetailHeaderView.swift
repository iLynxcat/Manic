import SwiftUI

struct ProjectDetailHeaderView: View {
	let project: AbletonProject

	private var fileSize: Int? {
		try? project.path.resourceValues(forKeys: [.fileSizeKey]).fileSize
	}
	private var fileSizeFormatted: String? {
		guard let fileSizeInBytes = fileSize else { return nil }

		let formatter = ByteCountFormatter()
		formatter.allowedUnits = [.useGB, .useMB]
		formatter.countStyle = .file
		formatter.includesUnit = true
		formatter.includesCount = true
		formatter.zeroPadsFractionDigits = false

		return formatter.string(fromByteCount: Int64(fileSizeInBytes))
	}

	var body: some View {
		VStack(alignment: .center) {
			Text(project.name)
				.font(.title2)
				.bold()

			HStack(alignment: .firstTextBaseline, spacing: 10) {
				Text("\(project.nonBackupSets.count) set\(project.nonBackupSets.count == 1 ? "" : "s")")

				if let fileSizeFormatted {
					Text(fileSizeFormatted)
				}
			}
			.font(.body)
			.foregroundStyle(.secondary)
		}
	}
}

#if DEBUG
#Preview {
	let project = generateDemoProject()
	let _ = generateDemoSet(in: project)

	ProjectDetailHeaderView(project: project)
		.padding()
}
#endif
