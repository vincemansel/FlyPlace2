//
//  FavoritePhotosInAFavoritePlaceTableViewController.h
//  FlyPlace2
//
//  Created by Vince Mansel on 11/28/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "Place.h"
#import "PhotoDetailViewController.h"

@interface FavoritePhotosInAFavoritePlaceTableViewController : CoreDataTableViewController
{
    PhotoDetailViewController *photoDetailViewController;
}

@property (nonatomic, retain) PhotoDetailViewController *photoDetailViewController;

- initWithPlace:(Place *)place;

@end
