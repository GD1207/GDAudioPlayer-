//
//  PlayManager.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/13.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayManager : NSObject

+ (instancetype) defaultManager;

/**
 *  准备播放
 *
 *  @param urlString 
 */
- (void)prepareToPlayMusicWithURl:(NSString *)urlString;

@end
