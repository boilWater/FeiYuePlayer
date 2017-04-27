//
//  SLEditorVideo.h
//  Pods
//
//  Created by liangbai on 2017/4/27.
//
//

#import <Foundation/Foundation.h>

typedef void(^SLEditorVideoCompletion) (id failure, id success);

@interface SLEditotVideo : NSObject

+ (instancetype)shareInstance;

- (void)editorVideoWithURL:(NSURL *)url videoRange:(NSRange)videoRange completion:(SLEditorVideoCompletion)editorVideoCompletion;

@end
