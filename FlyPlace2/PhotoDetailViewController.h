//
//  PhotoDetailViewController.h
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoDetailViewController : UIViewController <UIScrollViewDelegate, UISplitViewControllerDelegate>
{
//    NSDictionary *flickrInfo;
    Photo *photo;
    UIImageView *imageView;
}

//@property (retain, nonatomic) NSDictionary *flickrInfo;
@property (retain, nonatomic) Photo *photo;
@property (retain, nonatomic) UIImageView *imageView;

@end
