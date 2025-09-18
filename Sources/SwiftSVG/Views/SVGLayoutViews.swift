import SwiftUI

struct SVGListView: View {
    let svgItems: [SVGItem]
    let selectedItem: SVGItem?
    let onItemSelected: (SVGItem) -> Void
    
    var body: some View {
        List(svgItems) { item in
            HStack {
                SVGThumbnail(svgItem: item, size: CGSize(width: 32, height: 32))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.url.path)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
            .background(selectedItem?.id == item.id ? Color.accentColor.opacity(0.1) : Color.clear)
            .onTapGesture {
                onItemSelected(item)
            }
        }
        .listStyle(InsetListStyle())
    }
}

struct SVGGridView: View {
    let svgItems: [SVGItem]
    let selectedItem: SVGItem?
    let onItemSelected: (SVGItem) -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(svgItems) { item in
                    VStack(spacing: 8) {
                        SVGThumbnail(svgItem: item, size: CGSize(width: 80, height: 80))
                        
                        Text(item.name)
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 120, height: 120)
                    .background(selectedItem?.id == item.id ? Color.accentColor.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                    .onTapGesture {
                        onItemSelected(item)
                    }
                }
            }
            .padding()
        }
    }
}

struct SVGGalleryView: View {
    let svgItems: [SVGItem]
    let selectedItem: SVGItem?
    let onItemSelected: (SVGItem) -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 200), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(svgItems) { item in
                    VStack(spacing: 12) {
                        SVGThumbnail(svgItem: item, size: CGSize(width: 160, height: 160))
                        
                        VStack(spacing: 4) {
                            Text(item.name)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Text(item.url.lastPathComponent)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(width: 200, height: 220)
                    .padding()
                    .background(selectedItem?.id == item.id ? Color.accentColor.opacity(0.1) : Color.clear)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .shadow(radius: selectedItem?.id == item.id ? 4 : 1)
                    .onTapGesture {
                        onItemSelected(item)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview("List View") {
    let sampleItems = [
        SVGItem(url: URL(fileURLWithPath: "/sample1.svg"), content: "<svg>...</svg>"),
        SVGItem(url: URL(fileURLWithPath: "/sample2.svg"), content: "<svg>...</svg>")
    ]
    
    return SVGListView(
        svgItems: sampleItems,
        selectedItem: sampleItems.first,
        onItemSelected: { _ in }
    )
}

#Preview("Grid View") {
    let sampleItems = [
        SVGItem(url: URL(fileURLWithPath: "/sample1.svg"), content: "<svg>...</svg>"),
        SVGItem(url: URL(fileURLWithPath: "/sample2.svg"), content: "<svg>...</svg>")
    ]
    
    return SVGGridView(
        svgItems: sampleItems,
        selectedItem: sampleItems.first,
        onItemSelected: { _ in }
    )
}