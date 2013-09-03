//
//  ViewController.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/2/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "ArtistAnnotation.h"

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (strong, nonatomic) IBOutlet MKMapView *favoriteMap;

@end
