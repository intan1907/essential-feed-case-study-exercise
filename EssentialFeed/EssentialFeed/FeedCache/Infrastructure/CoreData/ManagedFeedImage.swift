//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 21/10/22.
//

import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged internal var id: UUID
    @NSManaged internal var imageDescription: String?
    @NSManaged internal var location: String?
    @NSManaged internal var url: URL
    @NSManaged internal var cache: ManagedCache
    
    internal static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managedImage = ManagedFeedImage(context: context)
            managedImage.id = local.id
            managedImage.imageDescription = local.description
            managedImage.location = local.location
            managedImage.url = local.url
            return managedImage
        })
    }
    
    internal var local: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
    }
}
