//
//  PWESearchTable.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 4/8/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PWESearchTableProtocol <NSObject>

-(void)tableTouched;

@end

@interface PWESearchTable : UITableView
@property (nonatomic, weak) IBOutlet id<PWESearchTableProtocol>searchTableDelegate;

@end
