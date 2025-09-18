import SwiftUI

struct SVGPreview: View {
    let svgItem: SVGItem?
    @State private var renderedImage: NSImage?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Binding var debugMode: Bool
    
    init(svgItem: SVGItem?, debugMode: Binding<Bool>) {
        self.svgItem = svgItem
        self._debugMode = debugMode
    }
    
    var body: some View {
        VStack {
            if let svgItem = svgItem {
                if isLoading {
                    ProgressView("Rendering SVG...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Error rendering SVG")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let image = renderedImage {
                    ScrollView([.horizontal, .vertical]) {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        Image(systemName: "doc.text")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("Unable to render SVG")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if debugMode {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Debug Information")
                            .font(.headline)
                        Text("File: \(svgItem.name)")
                        Text("Path: \(svgItem.url.path)")
                        Text("Content Length: \(svgItem.content.count) characters")
                        
                        ScrollView {
                            Text(svgItem.content)
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxHeight: 200)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            } else {
                VStack {
                    Image(systemName: "doc.badge.gearshape")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Select an SVG file to preview")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: svgItem) { newItem in
            renderSVG()
        }
        .onAppear {
            renderSVG()
        }
    }
    
    private func renderSVG() {
        guard let svgItem = svgItem else {
            renderedImage = nil
            errorMessage = nil
            return
        }
        
        // Guards to prevent the XML parser from running on empty or invalid data
        guard !svgItem.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "SVG content is empty"
            renderedImage = nil
            return
        }
        
        // Additional validation for SVG structure
        guard svgItem.content.contains("<svg") || svgItem.content.contains("<SVG") else {
            errorMessage = "Invalid SVG format - missing SVG root element"
            renderedImage = nil
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            let image = SVGRenderer.render(svgContent: svgItem.content, size: CGSize(width: 400, height: 400))
            
            await MainActor.run {
                self.renderedImage = image
                self.isLoading = false
                
                if image == nil {
                    self.errorMessage = "Failed to render SVG content"
                }
            }
        }
    }
}

#Preview {
    let sampleSVG = """
    <svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
        <rect width="100" height="100" fill="red"/>
    </svg>
    """
    
    let svgItem = SVGItem(
        url: URL(fileURLWithPath: "/sample.svg"),
        content: sampleSVG
    )
    
    return SVGPreview(svgItem: svgItem, debugMode: .constant(false))
}