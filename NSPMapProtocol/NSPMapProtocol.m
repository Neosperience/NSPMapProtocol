//
//  NSPMapProtocol.m
//  HelloJSMap
//
//  Created by Janos Tolgyesi on 01/07/16.
//  Copyright © 2016 Neosperience SpA. All rights reserved.
//

#import "NSPMapProtocol.h"

NSString* const NSPMapProtocolSchema = @"nspmap";

BOOL NSPMapProtocolParseStringToDoubles(NSString* string, double* a, double* b)
{
    NSScanner* scanner = [NSScanner scannerWithString:string];
    BOOL success = YES;
    success &= [scanner scanDouble:a];
    success &= [scanner scanString:@"," intoString:NULL];
    success &= [scanner scanDouble:b];
    return success;
}

@import MapKit;

@interface NSPMapProtocol ()

@property (strong, nonatomic) MKMapSnapshotter* snapshotter;

@end

@implementation NSPMapProtocol

+(void)load
{
    [NSURLProtocol registerClass:self];
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return ([request.URL.scheme isEqualToString:NSPMapProtocolSchema]);
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

-(void)startLoading
{
    NSURLComponents* components = [NSURLComponents componentsWithURL:self.request.URL resolvingAgainstBaseURL:NO];

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:components.queryItems.count];
    NSMutableArray* pinCoordinates = [NSMutableArray array];
    for (NSURLQueryItem* queryItem in components.queryItems) {

        // Map pins (can be more than one)
        if ([queryItem.name isEqualToString:@"p"]) {
            double pinLatitude = 0.0, pinLongitude = 0.0;
            if (NSPMapProtocolParseStringToDoubles(queryItem.value, &pinLatitude, &pinLongitude)) {
                CLLocationCoordinate2D pinCoordinate = CLLocationCoordinate2DMake(pinLatitude, pinLongitude);
                [pinCoordinates addObject:[NSValue valueWithMKCoordinate:pinCoordinate]];
            } else {
                NSLog(@"NSPMapProtocol warning: Invalid pin coordinate: p=%@", queryItem.value);
            }
        } else {
            params[queryItem.name] = queryItem.value;
        }
    }

    MKMapSnapshotOptions* snapshotOptions = [MKMapSnapshotOptions new];

    // Map type
    NSString* type = params[@"t"];
    if (type) {
        if ([type isEqualToString:@"k"]) snapshotOptions.mapType = MKMapTypeSatellite;
        else if ([type isEqualToString:@"h"]) snapshotOptions.mapType = MKMapTypeHybrid;
        else if ([type isEqualToString:@"m"]) snapshotOptions.mapType = MKMapTypeStandard;
        else {
            NSLog(@"NSPMapProtocol warning: Invalid map type: t=%@", type);
        }
    }

    // Location
    CLLocationCoordinate2D location = kCLLocationCoordinate2DInvalid;
    NSString* locationString = params[@"ll"];
    if (locationString) {
        double latitude = 0.0, longitude = 0.0;
        if (NSPMapProtocolParseStringToDoubles(locationString, &latitude, &longitude)) {
            location = CLLocationCoordinate2DMake(latitude, longitude);
        } else {
            NSLog(@"NSPMapProtocol warning: Invalid location: ll=%@", locationString);
        }
    }

    // Span
    MKCoordinateSpan span = MKCoordinateSpanMake(1.0, 1.0);
    NSString* spanString = params[@"spn"];
    if (spanString) {
        double latitudeDelta = 0.0, longitudeDelta = 0.0;
        if (NSPMapProtocolParseStringToDoubles(spanString, &latitudeDelta, &longitudeDelta)) {
            span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
        } else {
            NSLog(@"NSPMapProtocol warning: Invalid span: spn=%@", spanString);
        }
    }

    if (CLLocationCoordinate2DIsValid(location)) {
        snapshotOptions.region = MKCoordinateRegionMake(location, span);
    }

    // Width and height
    NSString* widthString = params[@"w"];
    double width = 400.0;
    if (widthString) {
        NSScanner* scanner = [NSScanner scannerWithString:widthString];
        if (![scanner scanDouble:&width]) {
            NSLog(@"NSPMapProtocol warning: Invalid width: w=%@", widthString);
        }
    }

    NSString* heightString = params[@"h"];
    double height = 400.0;
    if (heightString) {
        NSScanner* scanner = [NSScanner scannerWithString:heightString];
        if (![scanner scanDouble:&height]) {
            NSLog(@"NSPMapProtocol warning: Invalid height: h=%@", heightString);
        }
    }

    snapshotOptions.size = CGSizeMake(width, height);
    snapshotOptions.scale = [UIScreen mainScreen].scale;

    self.snapshotter = [[MKMapSnapshotter alloc] initWithOptions:snapshotOptions];
    [self.snapshotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {

        if (!error) {
            NSData* pngData = nil;
            if ([pinCoordinates count] > 0) {
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, YES, snapshot.image.scale);
                [snapshot.image drawAtPoint:CGPointZero];

                MKPinAnnotationView* pin = [MKPinAnnotationView new];
                pin.pinTintColor = [MKPinAnnotationView redPinColor];
                CGSize pinSize = CGSizeMake(pin.bounds.size.width / 2.0, pin.bounds.size.height / 2.0);
                CGPoint centerOffset = CGPointMake(pinSize.width * 0.25, pinSize.height * -.4);

                for (NSValue* pinCoordinateValue in pinCoordinates) {
                    CLLocationCoordinate2D pinCoordinate = [pinCoordinateValue MKCoordinateValue];
                    CGPoint pinAnchor = [snapshot pointForCoordinate:pinCoordinate];
                    CGRect pinRect = CGRectMake(pinAnchor.x - pinSize.width / 2.0 + centerOffset.x,
                                                pinAnchor.y - pinSize.height / 2.0 + centerOffset.y,
                                                pinSize.width,
                                                pinSize.height);
                    [pin drawViewHierarchyInRect:pinRect afterScreenUpdates:YES];
                }

                UIImage* finalImage = UIGraphicsGetImageFromCurrentImageContext();
                pngData = UIImagePNGRepresentation(finalImage);
            } else {
                pngData = UIImagePNGRepresentation(snapshot.image);
            }

            NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                                MIMEType:@"image/png"
                                                   expectedContentLength:pngData.length
                                                        textEncodingName:nil];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            [self.client URLProtocol:self didLoadData:pngData];
            [self.client URLProtocolDidFinishLoading:self];
        } else {
            [self.client URLProtocol:self didFailWithError:error];
        }
    }];
}

-(void)stopLoading
{
    [self.snapshotter cancel];
}

@end
