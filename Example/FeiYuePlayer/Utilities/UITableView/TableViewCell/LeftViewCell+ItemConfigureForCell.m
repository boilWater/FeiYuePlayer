//
//  LeftViewCell+ItemConfigureForCell.m
//  AnimationDome
//
//  Created by liangbai on 16/6/6.
//  Copyright © 2016年 liangbai. All rights reserved.
//

#import "LeftViewCell+ItemConfigureForCell.h"

@implementation LeftViewCell (ItemConfigureForCell)

-(void)ItemConfigureForCell:(id)item{
    self.textLabel.text = item;
}

@end
