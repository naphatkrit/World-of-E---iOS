//
//  PWERestorationPointObject.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/22/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWERestorationPointIndex : NSObject <NSCoding>
@property (nonatomic) PWEHexagonDrawType hexagonType;
@property (nonatomic, strong) NSIndexPath *secondLevelIndexPath;
@property (nonatomic, strong) NSIndexPath *thirdLevelIndexPath;
@end
