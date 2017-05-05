//
//  FYCompileAddWaterLayerVideo.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/5.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYCompileAddWaterLayerVideo.h"

@implementation FYCompileAddWaterLayerVideo

- (void)performWithAsset:(AVAsset *)asset completion:(FYCompileVideoCompletion)completion {
    if (!asset) {
        NSError *error = [NSError errorWithDomain:@"error:asset is blank" code:10241 userInfo:nil];
        completion(nil, nil, error);
        return;
    }
    
}

@end
