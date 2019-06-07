import Foundation
import Realm
import RealmSwift

class RealmService {
    
    static let shared = RealmService()
    
    private init() {  }
    
    // MARK: - Actions with groups
    
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save<T: Object>(items: [T],
                         configaration: Realm.Configuration = deleteIfMigration,
                         update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configaration)
        print(realm.configuration.fileURL)
        try realm.write {
            realm.add(items, update: update)
        }
    }
    
    static func get<T: Object>(_ type: T.Type,
                               configuaration: Realm.Configuration = deleteIfMigration) throws -> Results<T> {
        let realm = try Realm(configuration: configuaration)
        return realm.objects(type)
    }
    
    static func delete<T: Object>(items: [T],
                                  configaration: Realm.Configuration = deleteIfMigration,
                                  update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configaration)
        try realm.write {
            realm.delete(items)
        }
    }
    
    func savePhotos(_ photos: [Photo]) {
        do {
            let realm = try Realm()
            let oldPhotos = realm.objects(Photo.self)
            try realm.write {
                realm.delete(oldPhotos)
                realm.add(photos)
            }
        } catch {
            print("Ошибка записи групп", error)
        }
    }
}
