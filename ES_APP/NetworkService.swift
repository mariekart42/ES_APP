
// MARK: NetworkService Protocol
/// Protocol for implementing `NetworkService`s that can fetch `Element`s into an array
protocol NetworkService {
    associatedtype Element
    func fetch() async throws -> [Element]
}
