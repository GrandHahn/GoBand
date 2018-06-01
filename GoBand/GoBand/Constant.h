//
//  Constant.h
//  GoBand
//
//  Created by Hahn on 2018/6/1.
//  Copyright © 2018年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
extern NSInteger chessBoardLength; // 棋盘阶数，默认10
extern NSInteger winLength; // 几个棋连一起为赢，默认5

typedef enum : NSUInteger {
    DirectionTypeVetical = 0,//垂直竖方向
    DirectionTypeHorizontal = 1,//水平横方向
    DirectionType45Degree = 2,//斜方向"\"
    DirectionTypeNeg45Degree = 3,//斜方向"/"
} DirectionType; // 方向，米字型
