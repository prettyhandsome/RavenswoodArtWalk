//
//  ViewController.m
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/2/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    //location items:
    
    NSString *currentLatitude;
    NSString *currentLongitude;
}

@property (strong, nonatomic) CLLocationManager *myLocationManager;

- (void)startStandardUpdates;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma
#pragma mark Set Location

- (void)startStandardUpdates
{
    // Create the location manager if this object does not already have one.
    
    
    self.myLocationManager = [[CLLocationManager alloc] init];
    
    self.myLocationManager.delegate = ((id <CLLocationManagerDelegate>)(self));
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.myLocationManager startUpdatingLocation];
        //        //can also use startMonitoringSignificantLocationChanges to only access large changes, like cell tower switches
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"Please enable location services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    //    // Set a movement threshold for new events.
    self.myLocationManager.distanceFilter = 500;
    
    [self.myLocationManager startUpdatingLocation];
    
    //can probably stop monitoring again, once the location search string is formed, to save battery life? turn on again as needed?
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    currentLatitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    currentLongitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSLog(@"currently at lat:%f long:%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
//if you're using the location for something. 
    
}

#pragma mark Drop a Pin for original Flickr Photo selected (location of it)

-(void) dropPinForFlickPhoto {
    
    TappedPhotoAnnotation  *tappedPhotoAnnotation = [[TappedPhotoAnnotation alloc] init];
    
    tappedPhotoAnnotation.coordinate = CLLocationCoordinate2DMake([tappedPhotolatitude floatValue], [tappedPhotolongitude floatValue]);
    tappedPhotoAnnotation.title = tappedPhotoTitle;
    
    CLLocationCoordinate2D center = tappedPhotoAnnotation.coordinate;
    //ekh-i changed this from .2, just because zooming on the simulator was making me crazy, feel free to adjust back.
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    self.mapView.region = region;
    [self.mapView addAnnotation:tappedPhotoAnnotation];
    NSString *popUpString = [NSString stringWithFormat:@"Your photo is in %@,%@!",tappedPhotoCity,tappedPhoteState];
    popUpLabel.text = popUpString;
    
    
}

-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    NSString *reuseIdentifier= @"reuseIdentifier";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if ([annotation isKindOfClass:[TappedPhotoAnnotation class]]) {
        
        annotationView = [[TappedPhotoAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout= YES;
        // ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
        
    }
    
    
    if(annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:reuseIdentifier];
        
        annotationView.canShowCallout= YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        ((MKPinAnnotationView *)(annotationView)).pinColor= MKPinAnnotationColorPurple;
        ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
        
    } else {
        
        annotationView.annotation = annotation;
    }
    
    return annotationView;
    
    
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // add animation to  TappedPhotoAnnotation
        if ([aV.annotation isKindOfClass:[TappedPhotoAnnotationView class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options:UIViewAnimationCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
}



@end
