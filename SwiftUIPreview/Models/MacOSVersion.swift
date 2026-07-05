import Foundation

struct MacOSVersion: Comparable, Hashable {
    let major: Int
    let minor: Int
    let patch: Int

    static let current = MacOSVersion(ProcessInfo.processInfo.operatingSystemVersion)

    init(major: Int, minor: Int = 0, patch: Int = 0) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    init(_ version: OperatingSystemVersion) {
        self.major = version.majorVersion
        self.minor = version.minorVersion
        self.patch = version.patchVersion
    }

    static func < (lhs: MacOSVersion, rhs: MacOSVersion) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }

        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }

        return lhs.patch < rhs.patch
    }
}
