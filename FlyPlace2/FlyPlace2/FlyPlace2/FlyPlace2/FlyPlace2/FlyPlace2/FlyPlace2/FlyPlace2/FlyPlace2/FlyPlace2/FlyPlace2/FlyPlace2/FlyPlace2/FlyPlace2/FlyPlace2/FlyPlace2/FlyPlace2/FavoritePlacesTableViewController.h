//
//  FavoritePlacesTableViewController.h
//  FlyPlace2
//
//  Created by Vince Mansel on 11/27/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface FavoritePlacesTableViewController : CoreDataTableViewController
{
}

- initInManagedObjectContext:(NSManagedObjectContext *)context;

@end
