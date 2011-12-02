//
//  RecentlyViewedTableViewController.h
//  FlyPlace2
//
//  Created by Vince Mansel on 11/30/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "Place.h"
#import "PhotoXibViewController.h"

@interface RecentlyViewedTableViewController : CoreDataTableViewController
{
    PhotoXibViewController *photoDetailViewController;
}

@property (nonatomic, retain) PhotoXibViewController *photoDetailViewController;

- initWithPlace:(Place *)place withSortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end
