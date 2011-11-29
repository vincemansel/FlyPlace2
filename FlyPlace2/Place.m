//
//  Place.m
//  FlyPlace2
//
//  Created by Vince Mansel on 11/28/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import "Place.h"
#import "Photo.h"


@implementation Place

+ (Place *)placeWithName:placeName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", placeName];
    
    NSError *error = nil;
    place = [[context executeFetchRequest:request error:&error] lastObject];
    [request release];
    
    if (!error && !place) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = placeName;
    }
    
    return place;
}


@dynamic name;
@dynamic photos;
@dynamic favorites;

@end
