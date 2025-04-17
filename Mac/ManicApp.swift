import SwiftData
import SwiftUI

private let PROJECTS_VIEW_WIDTH: CGFloat = 712

@main
struct ManicApp: App {
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			AbletonProject.self,
			AbletonSet.self,
		])
		let modelConfiguration = ModelConfiguration(
			schema: schema,
			isStoredInMemoryOnly: false
		)

		do {
			return try ModelContainer(
				for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()

	var body: some Scene {
		WindowGroup {
			ProjectsView()
				.frame(
					minWidth: PROJECTS_VIEW_WIDTH, idealWidth: PROJECTS_VIEW_WIDTH,
					maxWidth: PROJECTS_VIEW_WIDTH,
					minHeight: 360, idealHeight: 612, maxHeight: .infinity)
		}
		.defaultSize(width: PROJECTS_VIEW_WIDTH, height: 612)
		.modelContainer(sharedModelContainer)
		.windowResizability(.contentSize)

		Settings {}
	}
}
