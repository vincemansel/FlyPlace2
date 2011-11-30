//
//  FavoritePlacesTableViewController.m
//  FlyPlace2
//
//  Created by Vince Mansel on 11/27/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import "FavoritePlacesTableViewController.h"
#import "FavoritePhotosInAFavoritePlaceTableViewController.h"


@implementation FavoritePlacesTableViewController

- initInManagedObjectContext:(NSManagedObjectContext *)context
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
        request.sortDescriptors = [NSArray arrayWithObject:
                                   [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                 ascending:YES
                                                                  selector:@selector(caseInsensitiveCompare:)]];
        
        request.predicate = [NSPredicate predicateWithFormat:@"favorites.@count != 0"];
        request.fetchBatchSize = 20;
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request
                                           managedObjectContext:context
                                           sectionNameKeyPath:@"firstLetterOfName"
                                           cacheName:@"MyPhotogCache"];
        [request release];
        
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"name";
        self.searchKey = @"name";
    }
    return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    Place *place = (Place *)managedObject;
//    NSLog(@"Favorites: %@", place.favorites);
    FavoritePhotosInAFavoritePlaceTableViewController *fpfptvc =
        [[FavoritePhotosInAFavoritePlaceTableViewController alloc] initWithPlace:place];
    fpfptvc.title = place.name;
    [self.navigationController pushViewController:fpfptvc animated:YES];
    [fpfptvc release];
}

@end
