//
//  ChessCell.h
//  GoBand
//
//  Created by Hahn on 2018/5/29.
//  Copyright © 2018年 Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ChessTypeNoChess,
    ChessTypeBlackChess,
    ChessTypeWhiteChess,
} ChessType;

@interface ChessCell : UICollectionViewCell

@property (nonatomic, assign) ChessType type;
@property (nonatomic, assign) NSInteger indexNumber;

@end
