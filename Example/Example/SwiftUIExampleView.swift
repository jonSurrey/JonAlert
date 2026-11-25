import JonAlert
import SwiftUI

struct SwiftUIExampleView: View {
    @State private var alert: FeedbackAlert?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(SampleAlert.allCases, id: \.self) { sample in
                        Button {
                            alert = sample.makeAlert()
                        } label: {
                            Label(sample.title, systemImage: sample.symbolName)
                        }
                    }
                } footer: {
                    Text(SampleAlert.footer)
                }
            }
            .navigationTitle("SwiftUI")
            .feedbackAlert(item: $alert)
        }
    }
}
