import Foundation

struct SVGItem: Identifiable, Hashable {
    let id = UUID()
    let url: URL
    let name: String
    let content: String
    let thumbnailData: Data?
    
    init(url: URL, content: String, thumbnailData: Data? = nil) {
        self.url = url
        self.name = url.lastPathComponent
        self.content = content
        self.thumbnailData = thumbnailData
    }
}

enum ViewLayout: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
    case gallery = "Gallery"
    
    var iconName: String {
        switch self {
        case .list: return "list.bullet"
        case .grid: return "grid"
        case .gallery: return "rectangle.grid.2x2"
        }
    }
}