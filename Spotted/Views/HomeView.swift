import SwiftUI
import SwiftData

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    let container: AppContainer

    @Query(sort: \Flight.date, order: .reverse)
    private var flights: [Flight]

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

                    AddFlightView(
                        viewModel: AddFlightViewModel(
                            repository: container.flightRepository,
                            aircraftService: container.aircraftService,
                            locationService: container.locationService
                        )
                    )

                }

            }

        }
    }

    private var listView: some View {

        List {

            ForEach(flights) { flight in

                NavigationLink {

                    FlightDetailView(
                        flight: flight,
                        viewModel: FlightDetailViewModel(
                            repository: container.flightRepository
                        ),
                        imageService: container.imageCacheService
                    )

                } label: {

                    listRow(for: flight)

                }

            }
            .onDelete(perform: deleteFlights)

        }
        .listStyle(.plain)
    }

    private func listRow(for flight: Flight) -> some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(flight.aircraftRegistration)
                .font(.headline)

            if let type = flight.aircraftType, !type.isEmpty {
                Text(type)
                    .foregroundColor(.secondary)
            } else {
                Text("Aircraft type unknown")
                    .foregroundColor(.secondary)
            }

            Text(flight.date, style: .date)
                .font(.caption2)
                .foregroundColor(.secondary)

        }
        .padding()

    }

    private var cardView: some View {

        ScrollView {

            LazyVGrid(columns: gridColumns, spacing: 16) {

                ForEach(flights) { flight in

                    NavigationLink {

                        FlightDetailView(
                            flight: flight,
                            viewModel: FlightDetailViewModel(
                                repository: container.flightRepository
                            ),
                            imageService: container.imageCacheService
                        )

                    } label: {

                        FlightCardView(flight: flight)

                    }

                }

            }
            .padding()

        }
    }

    private func deleteFlights(at offsets: IndexSet) {

        for index in offsets {

            try? viewModel.deleteFlight(flights[index])

        }
    }
}

enum ViewMode {

    case list
    case cards

}
