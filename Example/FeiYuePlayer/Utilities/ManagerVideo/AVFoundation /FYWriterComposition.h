//
//  FYWriterComposition.h
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAssetReader.h>
#import <AVFoundation/AVAssetWriter.h>

typedef void(^FYWriterCompositionBlock) (BOOL success, NSError * __autoreleasing *error);

@interface FYWriterComposition : NSObject

- (instancetype)initWriterCompositionWithAssetReader:(AVAssetReader *)assetReader
                                         assetWriter:(AVAssetWriter *)assetWriter;

- (void)startWriterCompositionWithBlock:(FYWriterCompositionBlock)block;

- (void)cancel;

@end
