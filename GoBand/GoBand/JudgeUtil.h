//
//  JudgeUtil.h
//  GoBand
//
//  Created by Hahn on 2018/6/1.
//  Copyright © 2018年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessCell.h"

@interface JudgeUtil : NSObject

+ (void)judge:(NSIndexPath *)indexPath typeForIndexPath:(ChessType(^)(NSIndexPath *indexPath))getType
       result:(void(^)(BOOL isWin, NSString *msg))resultBlock;

@end
