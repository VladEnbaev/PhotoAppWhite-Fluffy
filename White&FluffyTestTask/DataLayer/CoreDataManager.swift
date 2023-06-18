import UIKit
import CoreData

protocol DataManagerProtocol {
    func createPhoto(from model: UnsplashPhoto)
    func fetchPhotos() -> [UnsplashPhotoEntity]
    func fetchPhoto(with id: String) -> UnsplashPhotoEntity?
    func deleteAllPhotos()
    func deletePhoto(with id: String)
}

// MARK: - CRUD
class CoreDataManager : DataManagerProtocol {
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    public func createPhoto(from model: UnsplashPhoto) {
        guard let photoEntityDescription = NSEntityDescription.entity(forEntityName: "UnsplashPhotoEntity", in: context) else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UnsplashPhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id)
        let photos = try? context.fetch(fetchRequest) as? [UnsplashPhotoEntity]
        guard photos?.count == 0 else { return }
        
        let photo = UnsplashPhotoEntity(entity: photoEntityDescription, insertInto: context)
        photo.id = model.id
        photo.createdAt = model.createdAt
        photo.downloads = Int32(model.downloads ?? 0)
        photo.createdAt = model.createdAt
        photo.url = model.urls.regular
        photo.textDescription = model.description
        photo.username = model.user.username
        photo.likedByUser = model.likedByUser
        
        appDelegate.saveContext()
    }

    public func fetchPhotos() -> [UnsplashPhotoEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UnsplashPhotoEntity")
        do {
            return (try? context.fetch(fetchRequest) as? [UnsplashPhotoEntity]) ?? []
        }
    }

    public func fetchPhoto(with id: String) -> UnsplashPhotoEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UnsplashPhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let photos = try? context.fetch(fetchRequest) as? [UnsplashPhotoEntity]
            return photos?.first
        }
    }

    public func deleteAllPhotos() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UnsplashPhotoEntity")
        do {
            let photos = try? context.fetch(fetchRequest) as? [UnsplashPhotoEntity]
            photos?.forEach { context.delete($0) }
        }

        appDelegate.saveContext()
    }

    public func deletePhoto(with id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UnsplashPhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let photos = try? context.fetch(fetchRequest) as? [UnsplashPhotoEntity],
                  let photo = photos.first else { return}
            context.delete(photo)
        }

        appDelegate.saveContext()
    }
}

