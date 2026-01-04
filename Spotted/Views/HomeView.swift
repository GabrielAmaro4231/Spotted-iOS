import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var isLoggedIn: Bool

    @Query(sort: \Flight.date, order: .reverse)
    private var flights: [Flight]

    @Environment(\.modelContext)
    private var context

    @State private var showAddFlight = false
    @State private var viewMode: ViewMode = .list

    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            Group {
                switch viewMode {
                case .list:
                    listView
                case .cards:
                    cardView
                }
            }
            .navigationTitle("Spotted")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("View mode", selection: $viewMode) {
                        Image(systemName: "list.bullet")
                            .tag(ViewMode.list)
                        Image(systemName: "square.grid.2x2")
                            .tag(ViewMode.cards)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 220)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddFlight = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddFlight) {
                NavigationStack {
                    AddFlightView()
                }
            }
        }
    }

    private var listView: some View {
        List {
            ForEach(flights) { flight in
                NavigationLink {
                    FlightDetailView(flight: flight)
                } label: {
                    listRow(for: flight)
                }
                .listRowInsets(.init())
            }
            .onDelete(perform: deleteFlights)
        }
        .listStyle(.plain)
    }

    private func listRow(for flight: Flight) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(flight.aircraftRegistration)
                .font(.headline)

            aircraftTypeView(for: flight)

            Text(flight.date, style: .date)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var cardView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(flights) { flight in
                    NavigationLink {
                        FlightDetailView(flight: flight)
                    } label: {
                        card(for: flight)
                    }
                }
            }
            .padding()
        }
    }

    private func card(for flight: Flight) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(flight.aircraftRegistration)
                .font(.subheadline)
                .fontWeight(.semibold)

            aircraftTypeView(for: flight)
                .font(.caption)

            Spacer(minLength: 4)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 2, y: 1)
    }

    private func aircraftTypeView(for flight: Flight) -> some View {
        let type = flight.aircraftType?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return Group {
            if let type, !type.isEmpty {
                Text(type)
            } else {
                Text("Aircraft type unknown")
            }
        }
        .foregroundColor(.secondary)
    }

    private func deleteFlights(at offsets: IndexSet) {
        for index in offsets {
            context.delete(flights[index])
        }
    }
}

enum ViewMode {
    case list
    case cards
}
