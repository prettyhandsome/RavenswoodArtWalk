//
//  ArtistAnnotation.m
//  RavenswoodArtWalk
//
//  Created by Erin Hochstatter on 8/26/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "ArtistAnnotation.h"

@implementation ArtistAnnotation

@synthesize     coordinate;
@synthesize     title;
@synthesize     subtitle;
@synthesize     objectID;

+(ArtistAnnotation*)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title subtitle:(NSString*)subtitle andObjectID:(NSManagedObjectID*)objectID
{
    ArtistAnnotation *artistAnnotation = [[ArtistAnnotation alloc] init];
    artistAnnotation.coordinate = coordinate;
    artistAnnotation.title = title;
    artistAnnotation.subtitle = subtitle;
    artistAnnotation.objectID = objectID;
    
    return artistAnnotation;
}
@end

