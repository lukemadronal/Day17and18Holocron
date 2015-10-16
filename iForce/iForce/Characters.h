//
//  Characters.h
//  iForce
//
//  Created by Luke Madronal on 10/15/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Characters : NSObject

@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,strong) NSString *species;
@property (nonatomic,strong) NSString *homeworld;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSArray *faction;



@end
