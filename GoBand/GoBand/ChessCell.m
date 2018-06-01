//
//  ChessCell.m
//  GoBand
//
//  Created by Hahn on 2018/5/29.
//  Copyright © 2018年 Hahn. All rights reserved.
//

#import "ChessCell.h"

@interface ChessCell ()

@property (nonatomic, weak) UIView *chessView;
@property (nonatomic, weak) UILabel *indexLabel;

@end

@implementation ChessCell

- (void)setIndexNumber:(NSInteger)indexNumber {
    _indexNumber = indexNumber;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", indexNumber];
}

- (void)setType:(ChessType)type {
    _type = type;
    if (ChessTypeBlackChess == type) {
        self.chessView.hidden = NO;
        self.chessView.backgroundColor = [UIColor blackColor];
    } else if (ChessTypeWhiteChess == type) {
        self.chessView.hidden = NO;
        self.chessView.backgroundColor = [UIColor whiteColor];
    } else {
        self.chessView.hidden = YES;
        self.chessView.backgroundColor = [UIColor clearColor];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor yellowColor];
    UIView *chessView = [[UIView alloc] init];
    chessView.backgroundColor = [UIColor clearColor];
    [self addSubview:chessView];
    self.chessView = chessView;
    chessView.hidden = YES;
    
    UILabel *indexLabel = [[UILabel alloc] init];
    [self addSubview:indexLabel];
    self.indexLabel = indexLabel;
    indexLabel.textColor = [UIColor grayColor];
    indexLabel.font = [UIFont systemFontOfSize:13];
    indexLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.chessView.frame = self.bounds;
    self.chessView.layer.cornerRadius = self.chessView.bounds.size.width * 0.5;
    
    self.indexLabel.frame = self.bounds;
}

@end
