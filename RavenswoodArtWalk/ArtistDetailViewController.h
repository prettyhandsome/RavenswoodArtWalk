//
//  ArtistDetailViewController.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/14/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "Artist.h"
#import <MapKit/MapKit.h>

@interface ArtistDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *studioNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *blurbLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artImage;
@property (strong, nonatomic) IBOutlet UILabel *artistDetailLabel;

@property (strong, nonatomic) IBOutlet UIButton *visitWebsiteButtonOutlet;
- (IBAction)visitWebsiteButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *contactArtistButtonOutlet;
- (IBAction)contactArtistButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButtonOutlet;
- (IBAction)favoriteButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *blurbTextView;

@property (strong, nonatomic) IBOutlet MKMapView *artistLocation;

@property (strong, nonatomic) Artist *selectedArtist;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
