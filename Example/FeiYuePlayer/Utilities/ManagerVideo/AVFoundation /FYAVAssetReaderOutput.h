//
//  FYAVAssetReaderOutput.h
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface FYAVAssetReaderOutput : AVAssetReaderOutput

- (instancetype)assetReaderTrackOutputWithReaser:(AVAssetReader *)assetReader mediaType:(NSString *)mediaType;

@end

@interface FYAVAssetReaderTrackOutput : FYAVAssetReaderOutput

@end

@interface FYAVAssetReaderAudioMixOutput : FYAVAssetReaderOutput

@end
