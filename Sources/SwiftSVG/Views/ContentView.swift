import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationSplitView {
            VStack {
                // Layout picker in the sidebar header
                HStack {
                    Text("SVG Library")
                        .font(.headline)
                    
                    Spacer()
                    
                    Picker("View Layout", selection: $coordinator.currentLayout) {
                        ForEach(ViewLayout.allCases, id: \.self) { layout in
                            Image(systemName: layout.iconName)
                                .tag(layout)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 120)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Content based on selected layout
                Group {
                    switch coordinator.currentLayout {
                    case .list:
                        SVGListView(
                            svgItems: coordinator.svgItems,
                            selectedItem: coordinator.selectedSVGItem,
                            onItemSelected: coordinator.selectItem
                        )
                    case .grid:
                        SVGGridView(
                            svgItems: coordinator.svgItems,
                            selectedItem: coordinator.selectedSVGItem,
                            onItemSelected: coordinator.selectItem
                        )
                    case .gallery:
                        SVGGalleryView(
                            svgItems: coordinator.svgItems,
                            selectedItem: coordinator.selectedSVGItem,
                            onItemSelected: coordinator.selectItem
                        )
                    }
                }
                
                Spacer()
                
                // Footer with item count
                if !coordinator.svgItems.isEmpty {
                    Text("\(coordinator.svgItems.count) SVG file\(coordinator.svgItems.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }
            }
        } detail: {
            SVGPreview(svgItem: coordinator.selectedSVGItem, debugMode: $coordinator.debugMode)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                // Centralized toolbar menu
                Menu {
                    Section("Import") {
                        Button("Import Files...") {
                            importFiles()
                        }
                        .keyboardShortcut("i", modifiers: .command)
                        
                        Button("Scan Folder...") {
                            scanFolder()
                        }
                        .keyboardShortcut("o", modifiers: .command)
                        
                        Button("Load Samples") {
                            coordinator.loadSampleSVGs()
                        }
                    }
                    
                    Section("View") {
                        Button(coordinator.debugMode ? "Hide Debug Info" : "Show Debug Info") {
                            coordinator.toggleDebugMode()
                        }
                        .keyboardShortcut("d", modifiers: .command)
                    }
                    
                    Section("Actions") {
                        Button("Delete Selected") {
                            coordinator.deleteSelectedItem()
                        }
                        .disabled(coordinator.selectedSVGItem == nil)
                        .keyboardShortcut(.delete)
                        
                        Button("Clear All") {
                            coordinator.clearAll()
                        }
                        .disabled(coordinator.svgItems.isEmpty)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }
        }
        .navigationTitle("SwiftSVG")
    }
    
    private func importFiles() {
        let importedItems = SVGFileManager.importSVGFiles()
        coordinator.addSVGItems(importedItems)
        
        if importedItems.isEmpty {
            // Could show an alert here if needed
            print("No SVG files were imported")
        }
    }
    
    private func scanFolder() {
        let scannedItems = SVGFileManager.scanFolder()
        coordinator.addSVGItems(scannedItems)
        
        if scannedItems.isEmpty {
            // Could show an alert here if needed
            print("No SVG files found in the selected folder")
        }
    }
}

#Preview {
    ContentView()
}