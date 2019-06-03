import RealmSwift

let realm = try! Realm()

class RealmService {
    
    static let shared = RealmService()
    
    private init() {  }
    
    // MARK: - Actions with groups
    
    func saveGroups(_ groups: [Group]) {
        do {
            print(realm.configuration.fileURL)
            let oldGroups = realm.objects(Group.self)
            try realm.write {
                realm.delete(oldGroups)
                realm.add(groups)
            }
        } catch {
            print("Ошибка записи групп", error)
        }
    }
    
    func deleteGroups(_ groups: [Group]) {
        do {
            try realm.write {
                realm.delete(groups)
            }
        } catch {
            print("Ошибка удаления группы", error)
        }
    }
    
    func addGroupFromAllGroups(_ groups: [Group]) {
        do {
            try realm.write {
                realm.add(groups)
            }
        } catch {
            print("Ошибка добавления группы", error)
        }
    }
    
    // MARK: - Actions with friends
    
    func saveFriends(_ friends: [Friend]) {
        do {
            let oldFriends = realm.objects(Friend.self)
            try realm.write {
                realm.delete(oldFriends)
                realm.add(friends)
            }
        } catch {
            print("Ошибка записи групп", error)
        }
    }
    
    func loadFriends() -> [Friend] {
        do {
            let friendsFromRealm = realm.objects(Friend.self)
            return Array(friendsFromRealm)
        }
    }
    
    func savePhotos(_ photos: [Photo]) {
        do {
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
