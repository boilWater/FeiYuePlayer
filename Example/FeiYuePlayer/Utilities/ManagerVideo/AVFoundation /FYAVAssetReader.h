//
//  FYAVAssetReader.h
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class AVMutableComposition;
@class AVMutableVideoComposition;
@class AVMutableAudioMix;

@interface FYAVAssetReader : AVAssetReader

- (instancetype)initWithComposition:(AVMutableComposition *)composition videoComposition:(AVMutableVideoComposition *)videoComposition audioMix:(AVMutableAudioMix *)audioMix;

@end
