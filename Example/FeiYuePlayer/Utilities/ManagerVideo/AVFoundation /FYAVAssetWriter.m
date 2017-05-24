//
//  FYAVAssetWriter.m
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/24.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import "FYAVAssetWriter.h"

@interface FYAVAssetWriter (){
    NSURL *kOutputURL_;
}

@property(nonatomic, strong) AVAssetWriterInput *kVideoWriterInput;
@property(nonatomic, strong) AVAssetWriterInput *kAudioWriterInput;
@property(nonatomic, strong) NSString *kOutputFileType;

@end

@implementation FYAVAssetWriter


- (instancetype)initWriterWithVideoWriterInput:(AVAssetWriterInput *)videoWriterInput audioWriterInput:(AVAssetWriterInput *)audioWriterInput fileType:(NSString *)outputFileType {
    NSError *error = nil;
    if (_mOutputURL) {
        kOutputURL_ = _mOutputURL;
    }else {
        kOutputURL_ = [self saveVideoSourceIntoSandbox];
    }
    self = [super initWithURL:kOutputURL_ fileType:outputFileType error:&error];
    if (self) {
        self.kOutputFileType = [outputFileType copy];
        self.kAudioWriterInput = audioWriterInput;
        self.kVideoWriterInput = videoWriterInput;
        [self initAVAssetWriter];
    }
    return self;
}

#pragma mark - privatedMethod()

- (void)initAVAssetWriter {
    if ([self canAddInput:self.kVideoWriterInput]) {
        [self addInput:self.kVideoWriterInput];
    }
    if ([self canAddInput:self.kAudioWriterInput]) {
        [self addInput:self.kAudioWriterInput];
    }
}

- (NSURL *)saveVideoSourceIntoSandbox {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *stringSavedEditorVideo = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fyEditorVideo-%d.mov", arc4random() % 1000]];
    NSURL *urlSavedEditorVideo = [NSURL fileURLWithPath:stringSavedEditorVideo];
    return urlSavedEditorVideo;
}

#pragma mark - setter & getter

- (void)setMOutputURL:(NSURL *)mOutputURL {
    if (mOutputURL) {
        kOutputURL_ = mOutputURL;
    }
}

@end
