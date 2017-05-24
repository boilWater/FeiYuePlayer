//
//  FYAVAssetWriter.h
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface FYAVAssetWriter : AVAssetWriter

@property(nonatomic, strong) NSURL *mOutputURL;

- (instancetype)initWriterWithVideoWriterInput:(AVAssetWriterInput *)videoWriterInput audioWriterInput:(AVAssetWriterInput *)audioWriterInput fileType:(NSString *)outputFileType;

@end
