//
//  AppDelegate.m
//  iForce
//
//  Created by Luke Madronal on 10/15/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//bool serverAvailable;

-(NSString *) getDocumentsDirectory {
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    //NSLog(@"DocPath:%@",paths[0]);
    return paths[0];
}

-(BOOL)fileIsLocal:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self getDocumentsDirectory] stringByAppendingPathComponent:fileName];
    return [fileManager fileExistsAtPath:filePath];
}


-(void)getImageFromServer:(NSString *)localFileName fromUrl:(NSString *)fullFileName atIndexPath:(NSIndexPath *)indexPath checkTableView:(BOOL *)check withTableView:(UITableView *)tableView {
    NSURL *fileURL = [NSURL URLWithString:fullFileName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:fileURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:30.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSLog(@"LF:%@ FF:%@",localFileName,fullFileName);
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Length:%li error:%@",[data length],error);
        if ([data length] > 0 && error==nil) {
            NSString *savedFilePath = [[self getDocumentsDirectory] stringByAppendingPathComponent:localFileName];
            UIImage *imageTemp = [UIImage imageWithData:data];
            if (imageTemp != nil) {
                NSLog(@"iamge is not null");
                [data writeToFile:savedFilePath atomically:true];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotImageNotification" object:nil];
                    if (check) {
                        NSLog(@": )  : )  : )  : )");
                        // NSNotification goes here
                    }
                });
            }
        } else {
            NSLog(@"no data");
        }
    }]resume];
}

- (void)setupAppearances {
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setBackgroundColor:[UIColor clearColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAppearances];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
