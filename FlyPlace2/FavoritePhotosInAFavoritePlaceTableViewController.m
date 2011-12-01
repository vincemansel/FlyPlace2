//
//  FavoritePhotosInAFavoritePlaceTableViewController.m
//  FlyPlace2
//
//  Created by Vince Mansel on 11/28/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import "FavoritePhotosInAFavoritePlaceTableViewController.h"
#import "Photo.h"

@implementation FavoritePhotosInAFavoritePlaceTableViewController

@synthesize photoDetailViewController;

- initWithPlace:(Place *)place withSortDescriptor:(NSSortDescriptor *)sortDescriptor withPredicate:(NSPredicate *)predicate
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        NSManagedObjectContext *context = place.managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        request.predicate = predicate;
        request.fetchBatchSize = 20;
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                           initWithFetchRequest:request 
                                           managedObjectContext:context
                                           sectionNameKeyPath:nil
                                           cacheName:nil];
        [request release];
        
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"title";
        
    }
    return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    if (photoDetailViewController) [photoDetailViewController release];
    photoDetailViewController = [[PhotoDetailViewController alloc] init];
    
    self.photoDetailViewController.photo = (Photo *)managedObject;
    
    self.photoDetailViewController.title = self.photoDetailViewController.photo.title;
    self.photoDetailViewController.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    [self.navigationController pushViewController:self.photoDetailViewController animated:YES];
    NSLog(@"selected photo with title %@", self.photoDetailViewController.title);
}

@end
