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
            .navigationTitle("Flights")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Quit") {
                        isLoggedIn = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddFlight = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Picker("View mode", selection: $viewMode) {
                    Label("List", systemImage: "list.bullet")
                        .tag(ViewMode.list)
                    Label("Cards", systemImage: "square.grid.2x2")
                        .tag(ViewMode.cards)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(.bar)
            }
            .sheet(isPresented: $showAddFlight) {
                NavigationStack {
                    AddFlightView()
                }
            }
        }
    }

    // MARK: - List view

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

    // MARK: - Card view

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

    // MARK: - Row / Card components

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

    // MARK: - Aircraft type (single consistent style)

    private func aircraftTypeView(for flight: Flight) -> some View {
        let type = flight.aircraftType?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let displayText = (type?.isEmpty == false)
            ? type!
            : "Aircraft type unknown"

        return Text(displayText)
            .foregroundColor(.secondary) // ✅ identical everywhere
    }

    // MARK: - Actions

    private func deleteFlights(at offsets: IndexSet) {
        for index in offsets {
            context.delete(flights[index])
        }
    }
}

// MARK: - View mode enum

enum ViewMode {
    case list
    case cards
}
