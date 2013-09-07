//
//  ViewController.m
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/2/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Artist.h"
#import "ArtistAnnotationView.h"
#import "ArtistAnnotation.h"

@interface ViewController ()
{
    //location items:
    
    NSString *currentLatitude;
    NSString *currentLongitude;
    int       favoritesCount;
    NSString *favoritesString;
}

@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (strong, nonatomic) NSFetchedResultsController    *favoritesResultsController;


- (void)startStandardUpdates;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)getFavorites;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIFont *oswald = [UIFont fontWithName:@"Oswald" size:self.favoritesLabel.font.pointSize];
    self.favoritesLabel.font = oswald;
    self.navigationItem.title=@"Ravenswood Art Walk";

	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self startStandardUpdates];
    [self getFavorites];
    NSLog(@"favorites: %d", favoritesCount);
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
    CLLocationCoordinate2D center = currentLocation.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.008, 0.008);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    self.favoriteMap.region = region;
    
    
}

/*#pragma mark Drop a Pin for original Flickr Photo selected (location of it)

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
    
    
}*/

-(void)getFavorites
{
    
    NSManagedObjectContext *managedObjectContext = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    
    NSFetchRequest *favoritesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate * selectedPredicate = [NSPredicate predicateWithFormat:@"favorite = %d", 1];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:managedObjectContext];
    [favoritesFetchRequest setEntity:entity];
    [favoritesFetchRequest setPredicate: selectedPredicate];
    
    favoritesFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"studioName" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"rawLocation" ascending:NO]];
    
    
    self.favoritesResultsController= [[NSFetchedResultsController alloc]
                                    initWithFetchRequest:favoritesFetchRequest
                                    managedObjectContext:managedObjectContext
                                    sectionNameKeyPath:@"studioName"
                                    cacheName:@"nil"];
    
    NSError *error;
    
    BOOL success = [self.favoritesResultsController performFetch:&error];
    if (!success) {
        NSLog (@"Error: %@", error.description);
    }
     if ([[self.favoritesResultsController fetchedObjects] count] != 0)  {
    
         favoritesCount = self.favoritesResultsController.fetchedObjects.count;
    
        if (favoritesCount > 1)
        {
            favoritesString = [NSString stringWithFormat:@"You have %d favorite artists.", favoritesCount];
        
        } else {
        favoritesString = [NSString stringWithFormat:@"You have 1 favorite artist"];
        }
        
    }else{
        
        favoritesString =[NSString stringWithFormat:@"You have no favorites."];

    }
    
        self.favoritesLabel.text =favoritesString;
   
    for (Artist *favArtist in self.favoritesResultsController.fetchedObjects) {
        
        if (favArtist.address !=nil){
            NSLog(@"studio name: %@", favArtist.studioName);
        CLLocationCoordinate2D artistCoordinate = CLLocationCoordinate2DMake([favArtist.addressLat doubleValue], [favArtist.addressLng doubleValue]);
        ArtistAnnotation *artistAnnotation = [ArtistAnnotation initWithCoordinate:artistCoordinate title:favArtist.studioName subtitle:favArtist.medium andObjectID:favArtist.objectID];
        
        id<MKAnnotation> annotation = artistAnnotation;
            
        [self.favoriteMap addAnnotation:annotation];
            NSLog(@"annotation added at %f, %f", artistAnnotation.coordinate.latitude, artistAnnotation.coordinate.longitude);
        }
    }
    
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation{
    
    NSString *reuseIdentifier = @"reuseIdentifier";
    
    MKAnnotationView *annotationView = [self.favoriteMap dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if ([annotation isKindOfClass:[ArtistAnnotation class]]) {
        
        annotationView = [[ArtistAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout= YES;
        NSLog(@"annotationView added at %f, %f", annotation.coordinate.latitude, annotation.coordinate.longitude);

        
    }
    
    if(annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:reuseIdentifier];
        
        annotationView.canShowCallout= YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        ((MKPinAnnotationView *)(annotationView)).pinColor= MKPinAnnotationColorRed;
        ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
        
    } else {
        
        annotationView.annotation = annotation;
    }
    
    return annotationView;

}

/*-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *annotationView;
    
    for (annotationView in views) {
        
        // add animation to  TappedPhotoAnnotation
        if ([annotationView.annotation isKindOfClass:[TappedPhotoAnnotationView class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.favoriteMap.visibleMapRect, point)) {
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
*/


@end
