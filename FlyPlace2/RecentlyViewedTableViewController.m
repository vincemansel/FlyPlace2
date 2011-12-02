//
//  RecentlyViewedTableViewController.m
//  FlyPlace2
//
//  Created by Vince Mansel on 11/30/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import "RecentlyViewedTableViewController.h"
#import "Photo.h"

@implementation RecentlyViewedTableViewController

@synthesize photoDetailViewController;

#define Recently_Viewed_Expiration 48 * 60 * 60

- initWithPlace:(Place *)place withSortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        NSManagedObjectContext *context = place.managedObjectContext;
        
        NSTimeInterval timeInterval = Recently_Viewed_Expiration;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"whenViewed < %@",  date];
        
        
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
    photoDetailViewController = [[PhotoXibViewController alloc] init];
    
    self.photoDetailViewController.photo = (Photo *)managedObject;
    
    self.photoDetailViewController.title = self.photoDetailViewController.photo.title;
    self.photoDetailViewController.managedObjectContext = self.fetchedResultsController.managedObjectContext;

    [self.navigationController pushViewController:self.photoDetailViewController animated:YES];
    NSLog(@"selected photo with title %@", self.photoDetailViewController.title);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


@end