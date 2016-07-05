//
//  AppDelegate.m
//  NSPMapProtocolExample
//

//  Copyright (c) 2016 Neosperience SpA. All rights reserved.
//

#import "AppDelegate.h"

static NSString *tvBaseURL = @"http://localhost:9001/";
static NSString *tvBootURL = @"http://localhost:9001/application.js";

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    TVApplicationControllerContext *appControllerContext = [[TVApplicationControllerContext alloc] init];

    NSURL *javaScriptURL = [NSURL URLWithString:tvBootURL];
    appControllerContext.javaScriptApplicationURL = javaScriptURL;
    
    NSMutableDictionary *appControllerOptions = [appControllerContext.launchOptions mutableCopy];
    appControllerOptions[@"BASEURL"] = tvBaseURL;
    
    for (NSString *key in launchOptions) {
        appControllerOptions[key] = launchOptions[key];
    }
    appControllerContext.launchOptions = appControllerOptions;
    
    self.appController = [[TVApplicationController alloc] initWithContext:appControllerContext window:self.window delegate:self];

    return YES;
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
