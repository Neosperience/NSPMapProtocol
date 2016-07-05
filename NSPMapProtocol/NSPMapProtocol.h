//
//  NSPMapProtocol.h
//  NSPMapProtocol
//
//  Created by Janos Tolgyesi on 01/07/16.
//  Copyright © 2016 Neosperience SpA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * NSPMapProtocol registers the nspmap:// URL protocol schema in the URL loading system.
 * Making an NSURLRequest with this schema will return a png file containing a MapKit map snapshot.
 * 
 * example TVML snippet:
 * 
 * <img src="nspmap://?t=h&amp;ll=45.4654,9.1859&amp;spn=2,2&amp;w=400&amp;h=400&amp;p=45.4654,9.1859&amp;p=45.1404,10.0326"  width="400" height="400" />
 */
@interface NSPMapProtocol : NSURLProtocol

@end
