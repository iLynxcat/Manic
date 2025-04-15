import SwiftData
import SwiftUI

struct ProjectOverviewView: View {
	var project: AbletonProject
	
	var body: some View {
		ScrollView {
			VStack {
				GroupBox {
					VStack {
						ForEach(project.sets) { set in
							Button {} label: {
								
								Text(set.name)
							}.buttonStyle(.borderless)
						}
					}
				} label: {
					Label("Sets", systemImage: "document.fill")
				}
				.frame(maxWidth: .infinity)
			}
			.padding()
		}
		.frame(maxWidth: .infinity)
	}
}

#Preview("One set") {
	let container = try! ModelContainer(
		for: AbletonProject.self, AbletonSet.self,
		configurations: .init(
			isStoredInMemoryOnly: true
		))
	
	let demoProject = AbletonProject(
		name: "Floral Bounds Project",
		at: .homeDirectory
	)
	
	let demoSets: [AbletonSet] = [.init(
		in: demoProject,
		at: demoProject.path.appending(component: "awesome.als"),
		name: "awesome",
		modified: .now),
								  .init(
									in: demoProject,
									at: demoProject.path.appending(component: "awesome new version.als"),
									name: "awesome new ver",
									modified: .now)
	]
	
	
	ProjectOverviewView(project: demoProject)
		.modelContainer(for: AbletonProject.self, inMemory: true)
		.modelContainer(for: AbletonSet.self, inMemory: true)
		.frame(
			minWidth: 256,
			idealWidth: 420,
			maxWidth: 590,
			minHeight: 100,
			maxHeight: .infinity
		)
}
