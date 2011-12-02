//
//  PhotoXibViewController.h
//  FlyPlace2
//
//  Created by Vince Mansel on 12/1/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoXibViewController : UIViewController  <UIScrollViewDelegate, UISplitViewControllerDelegate>
{
    Photo *photo;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIActivityIndicatorView *spinner;
    
    NSManagedObjectContext *managedObjectContext;
    
    IBOutlet UIButton *favoriteButton;
    BOOL favoriteButtonIsSelected;
}

@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;
- (IBAction)toggleFavoriteButton:(id)sender;

@end
