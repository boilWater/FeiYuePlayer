//
//  ArrayDataSource.m
//  AnimationDome
//
//  Created by liangbai on 16/6/6.
//  Copyright © 2016年 liangbai. All rights reserved.
//

#import "ArrayDataSource.h"

@interface  ArrayDataSource()

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) NSString *identifer;
@property (nonatomic, copy) TakenConfigureCellBlock configureCellBlock;

@end

@implementation ArrayDataSource

-(id)init{
    return nil;
}
-(id)initItems:(NSArray *)mItems cellIdentifer:(NSString *)mIdentifer takenConfigureCellBlock:(TakenConfigureCellBlock)mConfigureCellBlock{
    self = [super init];
    if (self) {
        self.items = mItems;
        self.identifer = mIdentifer;
        self.configureCellBlock = [mConfigureCellBlock copy];
    }
    return self;
}
-(id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return self.items[indexPath.row];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifer forIndexPath:indexPath];
    
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    
    return cell;
}

@end
