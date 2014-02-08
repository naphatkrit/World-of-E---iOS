//
//  PWERestorationPointObject.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/22/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWERestorationPointIndex.h"
#define kHexagonTypeKey @"hexagon type"
#define kSecondLevelIndexKey @"second level"
#define kThirdLevelIndexKey @"third level"

@implementation PWERestorationPointIndex


-(NSString *)description
{
    return [NSString stringWithFormat:@"Restoration Index. Hexagon Type: %i. Second Level Index: section %i, item %i. Third Level Index: section %i, item %i", self.hexagonType, self.secondLevelIndexPath.section, self.secondLevelIndexPath.item, self.thirdLevelIndexPath.section, self.thirdLevelIndexPath.item];
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.hexagonType forKey:kHexagonTypeKey];
    [aCoder encodeObject:self.secondLevelIndexPath forKey:kSecondLevelIndexKey];
    [aCoder encodeObject:self.thirdLevelIndexPath forKey:kThirdLevelIndexKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _hexagonType = [aDecoder decodeIntForKey:kHexagonTypeKey];
        _secondLevelIndexPath = [aDecoder decodeObjectForKey:kSecondLevelIndexKey];
        _thirdLevelIndexPath = [aDecoder decodeObjectForKey:kThirdLevelIndexKey];
    }
    return self;
}
-(BOOL)isEqual:(id)object
{
    PWERestorationPointIndex *otherObject = object;
    if (self.hexagonType != otherObject.hexagonType) {
        return NO;
    }
    if (self.secondLevelIndexPath != otherObject.secondLevelIndexPath) {
        return NO;
    }
    if (self.thirdLevelIndexPath != otherObject.thirdLevelIndexPath) {
        return NO;
    }
    return YES;
}

@end
