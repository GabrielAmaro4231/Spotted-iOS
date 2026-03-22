# 📄 Spotted — Aplicativo de Registro de Observação de Aeronaves

## 📌 Introdução

O **Spotted** é um aplicativo iOS desenvolvido em **SwiftUI** que permite registrar e acompanhar aeronaves avistadas. A ideia é simples: o usuário informa a matrícula de uma aeronave, e o app registra automaticamente a localização, a data e, quando possível, complementa os dados com informações obtidas de uma API externa, como modelo e imagem.

Este projeto foi originalmente desenvolvido como parte da disciplina de desenvolvimento iOS. Para este trabalho, ele foi reorganizado e estruturado com foco em **clareza de código**, **separação de responsabilidades**, **testabilidade** e uso de **padrões comuns no desenvolvimento de software**.

---

## 📁 Organização do Repositório

Este repositório contém duas versões do projeto:

- A branch `main` corresponde à versão original desenvolvida para a disciplina de desenvolvimento iOS.  

- A branch `desenvolvimento_mobile_profissional` contém a versão reorganizada e utilizada para este trabalho, incluindo ajustes de arquitetura, testes e organização de código.

👉 **Para avaliação deste projeto, considerar o código presente na branch `desenvolvimento_mobile_profissional`.**

---

## 🎥 Vídeo Demonstrativo

https://youtu.be/TrOd7Q5rcpQ

---

## 🧭 Visão Geral da Estrutura

O projeto foi dividido em partes bem definidas, cada uma com uma responsabilidade específica:

```plaintext
Spotted/
├── App/
├── Models/
├── ViewModels/
├── Views/
├── Services/
├── Repositories/
├── Tests/
```

Essa divisão evita que a lógica fique concentrada em um único lugar e facilita tanto a leitura quanto a manutenção do código.

---

## 🧱 Como o aplicativo está organizado

A base do projeto segue o padrão MVVM, que separa a interface da lógica e dos dados.

O modelo principal é a entidade Flight, que representa um registro de aeronave:

```swift
@Model
final class Flight {
    var id: UUID
    var aircraftRegistration: String
    var aircraftType: String?
    var imageURL: String?
    var localImagePath: String?
    var latitude: Double
    var longitude: Double
    var date: Date
}
```

As telas (Views) são responsáveis apenas pela interface. Por exemplo, a HomeView exibe a lista de voos:

```swift
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
}
```

A lógica associada a essa tela fica no ViewModel:

```swift
final class HomeViewModel: ObservableObject {

    private let repository: FlightRepositoryProtocol

    init(repository: FlightRepositoryProtocol) {
        self.repository = repository
    }

    func deleteFlight(_ flight: Flight) throws {
        try repository.delete(flight)
    }
}
```

Essa separação evita que a View tenha lógica de negócio e facilita a manutenção.

---

## 🔌 Como as dependências são organizadas

Ao invés de criar objetos diretamente dentro das classes, as dependências são passadas via inicializador.

Um exemplo claro disso está no AddFlightViewModel:

```swift
init(
    repository: FlightRepositoryProtocol,
    aircraftService: AircraftServiceProtocol,
    locationService: LocationServiceProtocol
)
```

Isso permite que o ViewModel não dependa de implementações concretas, apenas de contratos (protocolos).

As implementações reais são centralizadas no AppContainer:

```swift
final class AppContainer {

    let aircraftService: AircraftServiceProtocol
    let imageCacheService: ImageCacheServiceProtocol
    let locationService: LocationServiceProtocol
    let flightRepository: FlightRepositoryProtocol

    init(context: ModelContext) {
        aircraftService = JetAPIService()
        imageCacheService = ImageCacheService()
        locationService = LocationService()
        flightRepository = SwiftDataFlightRepository(context: context)
    }
}
```

Esse padrão ajuda a manter o código desacoplado e facilita a substituição de implementações quando necessário.

---

## 💾 Como os dados são persistidos

O acesso aos dados é feito através de um repositório, que abstrai a forma como os dados são armazenados.

```swift
protocol FlightRepositoryProtocol {
    func save(_ flight: Flight) throws
    func delete(_ flight: Flight) throws
    func saveContext() throws
}
```

A implementação utiliza SwiftData:

```swift
final class SwiftDataFlightRepository: FlightRepositoryProtocol {

    private let context: ModelContext

    func save(_ flight: Flight) throws {
        context.insert(flight)
        try context.save()
    }
}
```

Isso permite que o restante da aplicação não precise conhecer detalhes da persistência.

---

## 🌐 Integrações externas

As responsabilidades relacionadas a serviços externos foram isoladas em classes específicas.

Por exemplo, a busca de informações da aeronave:

```swift
final class JetAPIService: AircraftServiceProtocol {

    func fetchAircraftInfo(registration: String) async throws -> JetAircraftInfo {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(JetAPIResponse.self, from: data)

        return JetAircraftInfo(
            model: decoded.images.first!.aircraft,
            imageURL: decoded.images.first!.image
        )
    }
}
```

Outro exemplo é o serviço de localização:

```swift
func requestLocation(completion: @escaping (CLLocation?) -> Void) {
    manager.requestWhenInUseAuthorization()
    manager.requestLocation()
}
```

E também o cache de imagens:

```swift
func loadImage(
    imageURL: String?,
    localPath: String?,
    id: UUID
) async -> (UIImage?, String?)
```

Cada serviço tem uma responsabilidade específica, evitando mistura de funções.

---

## 🌍 Suporte a idiomas (i18n)

O aplicativo também possui suporte a internacionalização, com textos disponíveis em:

- Português (Brasil)
- Inglês

Isso permite que a interface se adapte automaticamente ao idioma configurado no dispositivo do usuário.

---

## 🧪 Testes

A lógica principal foi escrita de forma a permitir testes isolados.
Um exemplo simples é a função de normalização:

```swift
func normalize(_ registration: String) -> String {
    registration
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: " ", with: "")
        .uppercased()
}
```

E o teste correspondente:

```swift
func testNormalizeRemovesSpacesAndUppercases() {
    let result = vm.normalize(" pt abc ")
    XCTAssertEqual(result, "PTABC")
}
```

Também é possível testar comportamentos mais completos, como salvar um voo:

```swift
func testSaveFlightCreatesFlight() async throws {

    vm.aircraftRegistration = "PTABC"
    vm.location = CLLocation(latitude: 10, longitude: 20)

    try await vm.saveFlight()

    XCTAssertEqual(repository.savedFlights.count, 1)
}
```

Para isso, são utilizadas implementações simuladas (mocks), como:

```swift
final class MockAircraftService: AircraftServiceProtocol {

    func fetchAircraftInfo(registration: String) async throws -> JetAircraftInfo {
        return JetAircraftInfo(
            model: "A320",
            imageURL: "https://test.com/image.jpg"
        )
    }
}
```

Essa abordagem permite testar o comportamento da aplicação sem depender de serviços reais, melhorando a testabilidade ao possibilitar a substituição de dependências por implementações simuladas durante os testes.

---

## 📱 Interface do usuário

O aplicativo possui quatro telas principais:

- Login
- Lista de voos (Home)
- Cadastro de novo voo
- Detalhes do voo

A navegação é feita utilizando NavigationStack, e os dados são exibidos diretamente a partir do modelo persistido:

```swift
@Query(sort: \Flight.date, order: .reverse)
private var flights: [Flight]
```

A tela de detalhes também inclui visualização de mapa:

```swift
MiniMapView(
    latitude: flight.latitude,
    longitude: flight.longitude,
    title: "Aircraft spotted here"
)
```

E carregamento assíncrono de imagens:

```swift
let result = await imageService.loadImage(...)
```

---

## 🧾 Considerações finais

O projeto foi estruturado com foco em organização e clareza, separando responsabilidades e evitando dependências diretas entre componentes.
A utilização de protocolos, divisão em camadas e testes unitários contribui para um código mais previsível e mais fácil de manter.
Apesar de ser um aplicativo simples, ele foi construído utilizando práticas comuns no desenvolvimento profissional, o que facilita sua evolução futura.

---