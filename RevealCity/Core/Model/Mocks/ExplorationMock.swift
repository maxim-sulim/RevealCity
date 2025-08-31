import Combine
import MapKit

final class ExplorationMock: ExplorationObserver {
    func getExploredData() -> ExplorationData {
        explorationData
    }
    
    var explorationDataPublished: AnyPublisher<ExplorationData, Never> { $explorationData.eraseToAnyPublisher() }
    
    @Published private var explorationData: ExplorationData = .init()
}
