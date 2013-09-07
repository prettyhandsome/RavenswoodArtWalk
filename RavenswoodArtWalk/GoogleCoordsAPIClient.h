//
//  GoogleCoordsAPIClient.h
//  RavenswoodArtWalk
//
//  Created by ehochs  on 9/5/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPClient.h>

extern NSString * const kGoogleAPIKey;
extern NSString * const kGoogleBaseURLString;

@interface GoogleCoordsAPIClient : AFHTTPClient

+(GoogleCoordsAPIClient *)sharedClient;


@end
