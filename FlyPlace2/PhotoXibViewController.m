//
//  PhotoXibViewController.m
//  FlyPlace2
//
//  Created by Vince Mansel on 12/1/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import "PhotoXibViewController.h"
#import "Photo.h"

@interface PhotoXibViewController()
@property (retain) IBOutlet UIScrollView *scrollView;
@property (retain) IBOutlet UIImageView *imageView;
@property (retain) IBOutlet UIActivityIndicatorView *spinner;
@property (retain) IBOutlet UIButton *favoriteButton;
@property BOOL favoriteButtonIsSelected;

@end

@implementation PhotoXibViewController

@synthesize scrollView, imageView;
@synthesize photo;
@synthesize spinner;
@synthesize favoriteButton;
@synthesize favoriteButtonIsSelected;

@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self.spinner startAnimating];
    [self.photo processImageDataWithBlock:^(NSData *imageData) {
        if (self.view.window) {
            UIImage *image = [UIImage imageWithData:imageData];
//            imageView.image = image;
//            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//            scrollView.contentSize = image.size;
            [self.spinner stopAnimating];
            
            photo.whenViewed = [NSDate date];
            
            if (photo.isFavorite) {
                self.favoriteButtonIsSelected = YES;
                [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
            }
            else {
                self.favoriteButtonIsSelected = NO;
                [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
            }
            
            CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
            
            NSString *statBarOrientation;
            CGFloat scale;
            
            // The iPhone/iPad applicationFrame w and h do not change with interfaceOrientation.
            
            switch ([self interfaceOrientation]) {
                case UIInterfaceOrientationPortrait:
                case UIInterfaceOrientationPortraitUpsideDown:      
                    statBarOrientation = @"UIInterfaceOrientationPortrait";
                    if (image.size.width >= image.size.height) {
                        if (image.size.width > applicationFrame.size.width)
                            scale = applicationFrame.size.width/image.size.width;
                        else
                            scale = image.size.width/applicationFrame.size.width;
                    }
                    else {
                        if (image.size.height > applicationFrame.size.height)
                            scale = image.size.height/applicationFrame.size.height;
                        else
                            scale = applicationFrame.size.height/image.size.height;
                    } 
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    statBarOrientation = @"UIInterfaceOrientationLandscape";
                    if (image.size.height >= image.size.width) {
                        if (image.size.height > applicationFrame.size.width)
                            scale = image.size.height/applicationFrame.size.width;
                        else
                            scale = applicationFrame.size.width/image.size.height;
                    }
                    else {
                        if (image.size.width > applicationFrame.size.height)
                            scale = image.size.width/applicationFrame.size.height;
                        else
                            scale = applicationFrame.size.height/image.size.width;
                    }
                    break;
                    
                default:
                    break;
            }
            //    NSLog(@"Orientation      = %@", statBarOrientation);
            //    NSLog(@"Scroll View  w:h = %g:%g", scrollView.bounds.size.width, scrollView.bounds.size.height);
            //    NSLog(@"Application w:h = %g:%g", applicationFrame.size.width, applicationFrame.size.height);
            //    NSLog(@"Image        w:h = %g:%g", image.size.width, image.size.height);
            //    NSLog(@"Scale            = %g", scale);
            [statBarOrientation release];
            
            CGRect imageRect = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);

            imageView.frame = imageRect;
            imageView.image = image;

#define MIN_ZOOM_SCALE 0.1
#define MAX_ZOOM_SCALE 3.0
            
            scrollView.contentSize = image.size;
            scrollView.bounces = YES;
            scrollView.bouncesZoom = YES;
            scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
            scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
            scrollView.delegate = self;
            
            [self saveContext];
        }
    }];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.imageView = nil;
    self.spinner = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Delegates

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

#pragma mark - Custom Methods

- (IBAction)toggleFavoriteButton:(id)sender {
    if (self.favoriteButtonIsSelected == YES) {
        self.favoriteButtonIsSelected = NO;
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
        self.photo.isFavorite = nil;
        [self saveContext];
    } else {
        self.favoriteButtonIsSelected = YES;
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
        self.photo.isFavorite = self.photo.whereTaken;
        [self saveContext];
    }    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContextLocal = self.managedObjectContext;
    if (managedObjectContextLocal != nil)
    {
        if ([managedObjectContextLocal hasChanges] && ![managedObjectContextLocal save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


- (void)dealloc
{
    [scrollView release];
    [imageView release];
    [photo release];
    [super dealloc];
}

@end
