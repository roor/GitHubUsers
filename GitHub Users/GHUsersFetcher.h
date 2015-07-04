//
//  GHUsersFetcher.h
//  GitHub Users
//
//  Created by Artem Podustov on 3/21/14.
//  Copyright (c) 2014 OLEArt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kFetcherDoneNotification;

@interface GHUsersFetcher : NSObject

+ (instancetype)sharedInstance;

- (void)loadData;

@end
