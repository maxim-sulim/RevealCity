
enum LocationError: Error {
    case permissionDenied
    case locationUnavailable
    case unknown(Error)
}

