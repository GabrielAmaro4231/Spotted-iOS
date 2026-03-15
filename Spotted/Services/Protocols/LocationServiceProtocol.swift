import CoreLocation

protocol LocationServiceProtocol {

    func requestLocation(completion: @escaping (CLLocation?) -> Void)

}
