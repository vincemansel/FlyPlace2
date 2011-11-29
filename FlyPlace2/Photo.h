//
//  Photo.h
//  FlyPlace2
//
//  Created by Vince Mansel on 11/28/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Photo : NSManagedObject

+ (Photo *)photoWithFlickrData:(NSDictionary *)flickrData placeWithName:placeName inManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSDate * whenViewed;
@property (nonatomic, retain) Place *whereTaken;
@property (nonatomic, retain) Place *isFavorite;

@end
