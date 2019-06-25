import Foundation
import Realm
import RealmSwift

class RealmService {

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
    
    static func savePhotos(_ photos: [Photo], friendId: Int) {

        guard let realm = try? Realm(),
              let friend = realm.object(ofType: Profile.self, forPrimaryKey: friendId) else { return }

        try? realm.write {
            realm.add(photos, update: .modified)
            friend.photos.append(objectsIn: photos)
        }
    }
    
    static func saveToMyGroup(groups: [Group]) {
        
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(groups, update: .modified)
        }
    }
}
