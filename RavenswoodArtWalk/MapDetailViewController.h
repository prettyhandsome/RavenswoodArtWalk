//
//  MapDetailViewController.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/14/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapDetailViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *tentMap;

@end
