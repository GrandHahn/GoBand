//
//  JudgeUtil.m
//  GoBand
//
//  Created by Hahn on 2018/6/1.
//  Copyright © 2018年 Hahn. All rights reserved.
//

#import "JudgeUtil.h"
#import "Constant.h"

@implementation JudgeUtil

+ (void)judge:(NSIndexPath *)indexPath typeForIndexPath:(ChessType(^)(NSIndexPath *indexPath))getType
       result:(void(^)(BOOL isWin, NSString *msg))resultBlock {
    NSInteger maxRow = chessBoardLength;
    NSInteger maxCol = chessBoardLength;
    NSInteger col = indexPath.item % maxCol;
    NSInteger row = indexPath.item / maxRow;
    DirectionType dirs[] = {DirectionTypeVetical, DirectionTypeHorizontal, DirectionType45Degree, DirectionTypeNeg45Degree};
    // 遍历四个方向是否有输赢
    for (int i = 0; i < 4; i++) {
        NSDictionary *result = [self judgeDirection:dirs[i] row:row col:col maxRow:maxRow maxCol:maxCol type:getType(indexPath) typeForIndexPath:getType];
        NSNumber *isWin = result[@"isWin"];
        NSString *msg = result[@"msg"];
        resultBlock(isWin.integerValue, msg);
    }
}

+ (NSDictionary *)judgeDirection:(DirectionType)direction
                             row:(NSInteger)row
                             col:(NSInteger)col
                          maxRow:(NSInteger)maxRow
                          maxCol:(NSInteger)maxCol
                            type:(ChessType)type
                typeForIndexPath:(ChessType(^)(NSIndexPath *indexPath))getType {
    NSDictionary *dict1 = [self judgeDirection:direction directionUp:YES row:row col:col maxRow:maxRow maxCol:maxCol type:type typeForIndexPath:getType];
    NSDictionary *dict2 = [self judgeDirection:direction directionUp:NO row:row col:col maxRow:maxRow maxCol:maxCol type:type typeForIndexPath:getType];
    NSNumber *rowR1 = dict1[@"row"];
    NSNumber *colR1 = dict1[@"col"];
    NSNumber *rowR2 = dict2[@"row"];
    NSNumber *colR2 = dict2[@"col"];
    if (   labs(rowR1.integerValue - rowR2.integerValue) >= (winLength - 1)
        || labs(colR1.integerValue - colR2.integerValue) >= (winLength - 1)) {
        NSString *msg = [NSString stringWithFormat:@"%ld到%ld",
                         rowR1.integerValue * chessBoardLength + colR1.integerValue,
                         rowR2.integerValue * chessBoardLength + colR2.integerValue];
        return @{@"isWin":@(YES), @"msg":msg};
    }
    return @{@"isWin":@(NO), @"msg":@""};;
}

/**
 * 获得某个方向上部分或下部分的最远的连续同色棋坐标。
 * 例：垂直方向，上部分，新增棋行列坐标（5，5），最大行列10。往上遍历(4,5)、(3,5)、(2,5)、(1,5)，如果只有(4,5)、(3,5)跟(5,5)连续同色，则返回距离最远的(3,5)。再次调用本方法，垂直方向，下部分，假设得出连续同色到(7,5)。最终判断(7,5)到(3,5)之间的棋子个数来决定输赢。
 * @param direction 方向，米字型
 * @param isDirectionUp 方向中的上部分还是下部分
 * @param row 新增的棋子的行
 * @param col 新增的棋子的列
 * @param maxRow 棋盘最大行
 * @param maxCol 棋盘最大列
 * @param type 新增的棋子的类型，黑或白
 * @return 该方向该部分最大的同色棋坐标，例：@{@"row":@1, @"col":@1};
 */
+ (NSDictionary *)judgeDirection:(DirectionType)direction
                     directionUp:(BOOL)isDirectionUp
                             row:(NSInteger)row
                             col:(NSInteger)col
                          maxRow:(NSInteger)maxRow
                          maxCol:(NSInteger)maxCol
                            type:(ChessType)type
                typeForIndexPath:(ChessType(^)(NSIndexPath *indexPath))getType {
    NSInteger aimRow = row;
    NSInteger aimCol = col;
    for (int i = 1; i < winLength; i++) {
        NSInteger aimRowTemp = row;
        NSInteger aimColTemp = col;
        if (DirectionTypeVetical == direction) {
            if (isDirectionUp) {
                aimRowTemp = row - i;
                aimColTemp = col;
            } else {
                aimRowTemp = row + i;
                aimColTemp = col;
            }
        } else if (DirectionTypeHorizontal == direction) {
            if (isDirectionUp) {
                aimRowTemp = row;
                aimColTemp = col - i;
            } else {
                aimRowTemp = row;
                aimColTemp = col + i;
            }
        } else if (DirectionType45Degree == direction) {
            if (isDirectionUp) {
                aimRowTemp = row - i;
                aimColTemp = col - i;
            } else {
                aimRowTemp = row + i;
                aimColTemp = col + i;
            }
        } else if (DirectionTypeNeg45Degree == direction) {
            if (isDirectionUp) {
                aimRowTemp = row - i;
                aimColTemp = col + i;
            } else {
                aimRowTemp = row + i;
                aimColTemp = col - i;
            }
        } else {
            return @{@"error" : @"error direction"};
        }
        if (   aimRowTemp < 0 || aimRowTemp >= maxRow
            || aimColTemp < 0 || aimColTemp >= maxCol) {
            break;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:aimRowTemp * maxCol + aimColTemp inSection:0];
        if (getType(indexPath) != type) {
            break;
        }
        aimRow = aimRowTemp;
        aimCol = aimColTemp;
    }
    return @{@"row":@(aimRow), @"col":@(aimCol)};
}

@end
