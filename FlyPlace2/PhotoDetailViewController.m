//
//  PhotoDetailViewController.m
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "FlickrFetcher.h"

@interface PhotoDetailViewController()
{
    UIActivityIndicatorView *activityIndicator;
}
@property (retain) UIActivityIndicatorView *activityIndicator;
@end

@implementation PhotoDetailViewController

//@synthesize flickrInfo;
@synthesize photo;
@synthesize imageView;
@synthesize activityIndicator;

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

#pragma mark -
#pragma mark SplitView Delegation methods

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    self.navigationItem.rightBarButtonItem = nil;
}

/*
 ------------------------------------------------------------------------
 Private methods used only in this file
 ------------------------------------------------------------------------
 */

#pragma mark -
#pragma mark Private methods


/* show the user that loading activity has started */

- (void) startAnimation
{
    if (!activityIndicator) activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [self.activityIndicator startAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
}


/* show the user that loading activity has stopped */

- (void) stopAnimation
{
    [self.activityIndicator stopAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = NO;
}

#pragma mark - View lifecycle

- (UIButton *)buttonWithTitle:(NSString *)title target:(id)target selector:(SEL)inSelector frame:(CGRect)frame image:(UIImage*)image {
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[button setTitle:title forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
	[button setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	[button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenDisabled = YES;
    button.adjustsImageWhenHighlighted = YES;
	[button setBackgroundColor:[UIColor clearColor]];	// in case the parent view draws with a custom color or gradient, use a transparent color
    [button autorelease];
    return button;
}

#define MIN_ZOOM_SCALE 0.1
#define MAX_ZOOM_SCALE 3.0

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{    
//    NSLog(@"PhotoDetailViewController: loadView: IN");
    if (photo) {
//        [self startAnimation];
        
        UIImage *image = [UIImage imageWithData:[FlickrFetcher imageDataForPhotoWithURLString:photo.imageURL]];
        
//        [self stopAnimation];
        
        // setup favorite button
        
        photo.whenViewed = [NSDate date];
        
        UIImage *buttonImage;
                        
        if (photo.isFavorite) {
            favoriteButtonIsSelected = YES;
            buttonImage = [UIImage imageNamed:@"green_button.png"];
        }
        else {
            favoriteButtonIsSelected = NO;
            buttonImage = [UIImage imageNamed:@"red_button.png"];
        }
        CGRect buttonFrame = CGRectMake(0, 0, buttonImage.size.width+60, buttonImage.size.height-10);
        favoriteButton = [self buttonWithTitle:@"Favorite" target:self selector:@selector(toggleFavoriteButton:) frame:buttonFrame image:buttonImage];

        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
        
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
        
        //imageView = [[UIImageView alloc] initWithImage:image];
        CGRect imageRect = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
        imageView = [[UIImageView alloc] initWithFrame:imageRect];
        imageView.image = image;
        
        scrollView.contentSize = image.size;
        scrollView.bounces = YES;
        scrollView.bouncesZoom = YES;
        scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
        scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
        scrollView.delegate = self;
        
        [scrollView addSubview:imageView];
        [scrollView addSubview:favoriteButton];
        self.view = scrollView;
    }
    else {
//        NSLog(@"PhotoDetailViewController: loadView: flickrInfo = %@", flickrInfo);
    }
   
//    NSLog(@"PhotoDetailViewController: loadView: OUT");

    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)toggleFavoriteButton:(id)sender {
    if (favoriteButtonIsSelected == YES) {
        favoriteButtonIsSelected = NO;
        [favoriteButton setBackgroundImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
        self.photo.isFavorite = nil;
    } else {
        favoriteButtonIsSelected = YES;
        [favoriteButton setBackgroundImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
        self.photo.isFavorite = self.photo.whereTaken;
    }    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;

}

- (void)dealloc
{
//    [flickrInfo release]; //This is a copy. The original info is actually "owned" by the PhotosTableViewController
    [photo release];
    [imageView release];
    [activityIndicator release];
    [super dealloc];
}

@end
