//
//  CSDrink.h
//  Coffee Shop MVC
//
//  Created by John Clem on 1/6/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSDrink : NSObject

@property (nonatomic) NSInteger numberOfShots;
@property (nonatomic) BOOL isIced;
@property (nonatomic) NSString *drinkName;
@property (nonatomic) NSString *drinkSize;

@end
