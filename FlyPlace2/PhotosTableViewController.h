//
//  PhotosTableViewController.h
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoXibViewController.h"

@interface PhotosTableViewController : UITableViewController
{
    NSDictionary *place;
    NSMutableArray *photosAtPlace;
    NSArray *sections;
    
    PhotoXibViewController *photoDetailViewController;
    
    NSManagedObjectContext *managedObjectContext;
}

@property (retain, nonatomic) NSDictionary *place;
@property (readonly) PhotoXibViewController *photoDetailViewController;

@property (retain) NSManagedObjectContext *managedObjectContext;

@end
