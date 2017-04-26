//
//  ArrayDataSource.h
//  AnimationDome
//
//  Created by liangbai on 16/6/6.
//  Copyright © 2016年 liangbai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TakenConfigureCellBlock) (id cell, id item);

@interface ArrayDataSource : NSObject<UITableViewDataSource>

-(id)initItems:(NSArray *)mItems cellIdentifer:(NSString *)mIdentifer takenConfigureCellBlock:(TakenConfigureCellBlock) mConfigureCellBlock;

-(id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
