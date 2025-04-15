import SwiftUI
import SwiftData

@main
struct ManicApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AbletonProject.self,
			AbletonSet.self,
        ])
        let modelConfiguration = ModelConfiguration(
			schema: schema,
			isStoredInMemoryOnly: true
		)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ProjectsView()
				.tint(.blue)
        }
		.modelContainer(sharedModelContainer)
    }
}

@inlinable public func printing<ValueType: Any>(_ value: ValueType) -> ValueType {
	debugPrint("\(value)")
	return value
}

@inlinable public func printing<ValueType: Any>(_ prefix: String = "", _ value: ValueType, _ suffix: String = "") -> ValueType {
	debugPrint("\(prefix)\(value)\(suffix)")
	return value
}
