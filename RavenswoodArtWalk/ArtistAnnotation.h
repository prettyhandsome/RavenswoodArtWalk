//
//  ArtistAnnotation.h
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/26/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface ArtistAnnotation : NSObject <MKAnnotation>

+(ArtistAnnotation*)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title subtitle:(NSString*)subtitle andObjectID:(NSManagedObjectID*)objectID;

@property (nonatomic, assign) CLLocationCoordinate2D  coordinate;
@property (copy,nonatomic)    NSString                *title;
@property (copy,nonatomic)    NSString                *subtitle;
@property (copy,nonatomic)    NSManagedObjectID       *objectID;
    




@end
