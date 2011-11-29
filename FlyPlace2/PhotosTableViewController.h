//
//  PhotosTableViewController.h
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDetailViewController.h"

@interface PhotosTableViewController : UITableViewController
{
    NSDictionary *place;
    NSMutableArray *photosAtPlace;
    NSArray *sections;
    
    PhotoDetailViewController *photoDetailViewController;
    
    NSManagedObjectContext *managedObjectContext;
}

@property (retain, nonatomic) NSDictionary *place;
@property (readonly) PhotoDetailViewController *photoDetailViewController;

@property (copy) NSManagedObjectContext *managedObjectContext;

@end
