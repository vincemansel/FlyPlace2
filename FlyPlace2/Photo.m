//
//  Photo.m
//  FlyPlace2
//
//  Created by Vince Mansel on 11/28/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import "Photo.h"
#import "Place.h"
#import "FlickrFetcher.h"

@implementation Photo

+ (Photo *)photoWithFlickrData:(NSDictionary *)flickrData placeWithName:(NSString *)placeName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueId = %@", [flickrData objectForKey:@"id"]];
    
    NSError *error = nil;
    photo = [[context executeFetchRequest:request error:&error] lastObject];
    [request release];
    
    if (!error && !photo) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.uniqueId = [flickrData objectForKey:@"id"];
        photo.title = [flickrData objectForKey:@"title"];
        photo.imageURL = [FlickrFetcher urlStringForPhotoWithFlickrInfo:flickrData format:FlickrFetcherPhotoFormatLarge];
        photo.whereTaken = [Place placeWithName:placeName inManagedObjectContext:context];
        photo.whenViewed = nil;
        photo.isFavorite = nil;
    }
    
    return photo;
}

- (void)processImageDataWithBlock:(void (^)(NSData *imageData))processImage
{
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("Flickr download in Photo", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *imageData = [FlickrFetcher imageDataForPhotoWithURLString:self.imageURL];
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
}

@dynamic imageURL;
@dynamic title;
@dynamic uniqueId;
@dynamic whenViewed;
@dynamic whereTaken;
@dynamic isFavorite;

@end
