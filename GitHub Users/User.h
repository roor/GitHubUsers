//
//  User.h
//  GitHub Users
//
//  Created by Artem Podustov on 3/21/14.
//  Copyright (c) 2014 OLEArt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *login;
@property (nonatomic) NSInteger userId;

@end
