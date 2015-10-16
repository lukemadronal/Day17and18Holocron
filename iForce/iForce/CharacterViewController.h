//
//  CharacterViewController.h
//  iForce
//
//  Created by Luke Madronal on 10/15/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Characters.h"

@interface CharacterViewController : UIViewController

@property (nonatomic,strong) NSDictionary *currentCharacter;
@property (nonatomic,strong) NSString     *currentImageFilePath;

@end
