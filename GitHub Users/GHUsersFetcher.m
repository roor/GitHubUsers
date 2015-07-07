//
//  GHUsersFetcher.m
//  GitHub Users
//
//  Created by Artem Podustov on 3/21/14.
//  Copyright (c) 2014 OLEArt. All rights reserved.
//

#import "GHUsersFetcher.h"
#import "User.h"

static NSString *serverURLString = @"https://api.github.com/users";
NSString *kFetcherDoneNotification = @"kFetcherDoneNotification";

@interface GHUsersFetcher ()

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation GHUsersFetcher

+ (instancetype)sharedInstance
{
    static GHUsersFetcher *fetcher = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fetcher = [[GHUsersFetcher alloc] init];
    });
    
    return fetcher;
}

- (id)init
{
    if (self = [super init]) {
        _data = [NSMutableArray array];
    }
    
    return self;
}

- (void)loadData
{
    NSLog(@"connection started");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"new thread started");
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:serverURLString]];
        
        NSURLResponse *response = nil;
        NSError *errorRequest = nil;
        
        NSData *someData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorRequest];
            
        NSError *error = nil;
        NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:someData
                                                            options:0
                                                              error:&error];
        if (error) {
            NSLog(@"%@", error.description);
        }
        
        NSLog(@"parsing started");
        for (NSDictionary *userData in jsonData) {
            User *user = [User new];
            [user setLogin:[userData objectForKey:@"login"]];
            [user setUserId:[[userData objectForKey:@"id"] integerValue]];
            
            [self.data addObject:user];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetcherDoneNotification object:[self class] userInfo:@{@"data": self.data}];
        });
    });
}

@end
