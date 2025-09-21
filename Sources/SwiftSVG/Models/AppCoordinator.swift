import SwiftUI
import Foundation

class AppCoordinator: ObservableObject {
    @Published var svgItems: [SVGItem] = []
    @Published var selectedSVGItem: SVGItem?
    @Published var currentLayout: ViewLayout = .list
    @Published var debugMode = false
    
    // Safely dispatch updates to prevent "Publishing changes from within view updates"
    func selectItem(_ item: SVGItem?) {
        Task { @MainActor in
            selectedSVGItem = item
        }
    }
    
    func setLayout(_ layout: ViewLayout) {
        Task { @MainActor in
            currentLayout = layout
        }
    }
    
    func toggleDebugMode() {
        Task { @MainActor in
            debugMode.toggle()
        }
    }
    
    func addSVGItems(_ items: [SVGItem]) {
        Task { @MainActor in
            svgItems.append(contentsOf: items)
        }
    }
    
    func deleteSelectedItem() {
        guard let selectedItem = selectedSVGItem else { return }
        
        Task { @MainActor in
            svgItems.removeAll { $0.id == selectedItem.id }
            selectedSVGItem = nil
        }
    }
    
    func clearAll() {
        Task { @MainActor in
            svgItems.removeAll()
            selectedSVGItem = nil
        }
    }
    
    func loadSampleSVGs() {
        let samples = createSampleSVGs()
        addSVGItems(samples)
    }
    
    private func createSampleSVGs() -> [SVGItem] {
        let samples: [(String, String)] = [
            ("Circle", """
                <svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="50" cy="50" r="40" fill="blue" stroke="black" stroke-width="2"/>
                </svg>
                """),
            ("Rectangle", """
                <svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
                    <rect x="10" y="10" width="80" height="80" fill="red" stroke="black" stroke-width="2"/>
                </svg>
                """),
            ("Triangle", """
                <svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
                    <polygon points="50,10 90,90 10,90" fill="green" stroke="black" stroke-width="2"/>
                </svg>
                """),
            ("Star", """
                <svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
                    <polygon points="50,5 61,35 95,35 68,57 79,91 50,70 21,91 32,57 5,35 39,35" fill="gold" stroke="black" stroke-width="1"/>
                </svg>
                """)
        ]
        
        return samples.map { name, content in
            SVGItem(
                url: URL(fileURLWithPath: "/samples/\(name.lowercased()).svg"),
                content: content
            )
        }
    }
}