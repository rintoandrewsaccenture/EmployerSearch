import Foundation

enum CacheError: Error {
    case cacheDirectoryNotFound
}

protocol EmployerCacheProtocol {
    func save(_ employers: [Employer], for query: String)
    func load(for query: String) -> [Employer]?
}

final class EmployerCache: EmployerCacheProtocol {
    private let secureStorage: SecureStorageProtocol

    init?(secureStorage: SecureStorageProtocol? = nil) {
        if let providedStorage = secureStorage {
            self.secureStorage = providedStorage
        } else {
            return nil
        }
    }

    func fileURL(for query: String) throws -> URL {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw CacheError.cacheDirectoryNotFound
        }
#if DEBUG
        print(cacheDirectory)
#endif
        let filename = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent("employer_\(filename).secure".lowercased())
    }

    func save(_ employers: [Employer], for query: String) {
        let entry = CachedEntry(data: employers, timestamp: Date())

        do {
            let url = try fileURL(for: query)
            let plainData = try JSONEncoder().encode(entry)
            let encryptedData = try secureStorage.encrypt(plainData)
            try encryptedData.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save secure cache for '\(query)': \(error)")
        }
    }

    func load(for query: String) -> [Employer]? {
        do {
            let url = try fileURL(for: query)
            guard FileManager.default.fileExists(atPath: url.path) else { return nil }
            let encryptedData = try Data(contentsOf: url)
            let decryptedData = try secureStorage.decrypt(encryptedData)
            let entry = try JSONDecoder().decode(CachedEntry.self, from: decryptedData)

            if entry.isExpired {
                try? FileManager.default.removeItem(at: url)
                return nil
            }

            return entry.data
        } catch {
            print("Failed to load secure cache for '\(query)': \(error)")
            return nil
        }
    }

    struct CachedEntry: Codable {
        let data: [Employer]
        let timestamp: Date

        var isExpired: Bool {
            return Date().isOlderThanOneWeek
        }
    }
}

