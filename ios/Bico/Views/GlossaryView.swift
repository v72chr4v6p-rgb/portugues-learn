import SwiftUI

struct GlossaryView: View {
    let dialect: Dialect

    var body: some View {
        VerbExplorerView(dialect: dialect)
    }
}
