//
// Copyright (c) 2014 Zhugeio. All rights reserved.

#import "MPTypeDescription.h"

@implementation MPTypeDescription

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _name = [dictionary[@"name"] copy];
    }

    return self;
}

@end
