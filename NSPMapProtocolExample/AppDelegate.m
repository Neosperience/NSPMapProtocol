//
//  AppDelegate.m
//  NSPMapProtocolExample
//

//  Copyright (c) 2016 Neosperience SpA. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    TVApplicationControllerContext *appControllerContext = [[TVApplicationControllerContext alloc] init];

    NSURL *javaScriptURL = [[NSBundle mainBundle] URLForResource:@"application" withExtension:@"js"];

    appControllerContext.javaScriptApplicationURL = javaScriptURL;
    
    self.appController = [[TVApplicationController alloc] initWithContext:appControllerContext
                                                                   window:self.window
                                                                 delegate:self];

    [self nativeExample];

    return YES;
}

- (void) nativeExample
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"nspmap://?ll=45.4654,9.1859&w=400&h=400"]];
        UIImage* image = [UIImage imageWithData:data];
        NSLog(@"Got an image of size: %@", NSStringFromCGSize(image.size));
    });
}

#pragma mark TVApplicationControllerDelegate

- (void)appController:(TVApplicationController *)appController didFinishLaunchingWithOptions:(nullable NSDictionary<NSString *, id> *)options {
    NSLog(@"appController:didFinishLaunchingWithOptions: invoked with options: %@", options);
}

- (void)appController:(TVApplicationController *)appController didFailWithError:(NSError *)error {
    NSLog(@"appController:didFailWithError: invoked with error: %@", error);
    
    NSString *title = @"Error Launching Application";
    NSString *message = error.localizedDescription;
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self.appController.navigationController presentViewController:alertController animated:YES completion: ^() {
        // ...
    }];
}

- (void)appController:(TVApplicationController *)appController didStopWithOptions:(nullable NSDictionary<NSString *, id> *)options {
    NSLog(@"appController:didStopWithOptions: invoked with options: %@", options);
}

@end
