//
//  GoogleCoordsAPIClient.m
//  RavenswoodArtWalk
//
//  Created by ehochs  on 9/5/13.
//  Copyright (c) 2013 Erin Hochstatter. All rights reserved.
//

#import "GoogleCoordsAPIClient.h"
#import <AFJSONRequestOperation.h>

NSString *const kGoogleBaseURLString =@"http://maps.googleapis.com";

@implementation GoogleCoordsAPIClient

+(GoogleCoordsAPIClient *)sharedClient {
    static GoogleCoordsAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kGoogleBaseURLString]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    return self;
}

@end
