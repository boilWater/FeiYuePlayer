//
//  FYRotateVideo.h
//  FeiYuePlayer
//
//  Created by liangbai on 2017/5/2.
//  Copyright © 2017年 boilwater. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SLRotateVideoComplation) (id failure, id sueccess);

@interface FYRotateVideo : NSObject

- (void)rotateVideoWithURL:(NSURL *)url degreeOfAngle:(CGFloat)angle complation:(SLRotateVideoComplation)rotateVideoComplation;

@end
