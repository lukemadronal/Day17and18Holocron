//
//  AppDelegate.h
//  iForce
//
//  Created by Luke Madronal on 10/15/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)getImageFromServer:(NSString *)localFileName fromUrl:(NSString *)fullFileName atIndexPath:(NSIndexPath *)indexPath checkTableView:(BOOL *)check withTableView:(UITableView *)tableView;

-(BOOL)fileIsLocal:(NSString *)fileName;

-(NSString *) getDocumentsDirectory;


@end

