//
//  YAPackerRace.h
//  BusinessInSpace
//
//  Created by Yousry Abdallah on 03.09.12.
//  Copyright (c) 2012 yousry.de. All rights reserved.
//

#import "YAAlienRace.h"
#import "YAImpersonatorMover.h"
#import <Foundation/Foundation.h>
@class YARenderLoop;


@interface YAPackerRace : YAAlienRace

- (id) initInWorld: (YARenderLoop*) world PlayerId: (int) id;
@end
