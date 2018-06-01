//
//  ViewController.m
//  GoBand
//
//  Created by Hahn on 2018/5/29.
//  Copyright © 2018年 Hahn. All rights reserved.
//

#import "ViewController.h"
#import "ChessCell.h"
#import "ChessHistoryItem.h"
#import "Constant.h"
#import "JudgeUtil.h"
static NSString * const ChessCellID = @"ChessCell";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<ChessHistoryItem *> *chessHistory;
@property (nonatomic, assign) BOOL blackTurn;
@property (nonatomic, weak) UICollectionView *chessBoard;
@property (nonatomic, weak) UILabel *tips;

@end

@implementation ViewController

#pragma mark - lazy load
- (NSMutableArray<ChessHistoryItem *> *)chessHistory {
    if (!_chessHistory) {
        _chessHistory = [NSMutableArray array];
    }
    return _chessHistory;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    [self setupButton];
    [self setupChessBoard];
}

- (void)setupButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:backButton];
    [backButton setTitle:@"悔棋" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 100, 100, 50);
    backButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tips = [[UILabel alloc] init];
    [self.view addSubview:tips];
    self.tips = tips;
    tips.frame = CGRectMake(CGRectGetMaxX(backButton.frame) + 20, 100, 100, 50);
    tips.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.text = @"白先手";
    tips.numberOfLines = 2;
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:reloadButton];
    [reloadButton setTitle:@"重开" forState:UIControlStateNormal];
    reloadButton.frame = CGRectMake(CGRectGetMaxX(tips.frame) + 20, 100, 100, 50);
    reloadButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupChessBoard {
    CGFloat chessboardWH = ScreenW - 40;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 200, chessboardWH, chessboardWH) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.chessBoard = collectionView;
    collectionView.backgroundColor = [UIColor orangeColor];
    layout.itemSize = CGSizeMake(chessboardWH / chessBoardLength - 1, chessboardWH / chessBoardLength - 1);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    [collectionView registerClass:[ChessCell class] forCellWithReuseIdentifier:ChessCellID];
    collectionView.delegate = self;
    collectionView.dataSource = self;
}

#pragma mark - event
- (void)backButtonClick {
    if (self.chessHistory.count <= 0) {
        return;
    }
    ChessHistoryItem *item = self.chessHistory.lastObject;
    ChessCell *cell = (ChessCell *)[self.chessBoard cellForItemAtIndexPath:item.indexPath];
    cell.type = ChessTypeNoChess;
    [self.chessHistory removeObject:item];
    self.blackTurn = !self.blackTurn;
    self.tips.text = self.blackTurn ? @"轮到黑" : @"轮到白";
}

- (void)reloadButtonClick {
    [self.chessBoard reloadData];
    [self.chessHistory removeAllObjects];
    self.tips.text = @"白先手";
    self.blackTurn = NO;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChessCell *cell = (ChessCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.type != ChessTypeNoChess) {
        return;
    }
    if (self.blackTurn) {
        cell.type = ChessTypeBlackChess;
    } else {
        cell.type = ChessTypeWhiteChess;
    }
    self.blackTurn = !self.blackTurn;
    self.tips.text = self.blackTurn ? @"轮到黑" : @"轮到白";
    ChessHistoryItem *item = [[ChessHistoryItem alloc] init];
    item.indexPath = indexPath;
    [self.chessHistory addObject:item];
    [self judge:indexPath];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return chessBoardLength * chessBoardLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChessCellID forIndexPath:indexPath];
    cell.indexNumber = indexPath.item;
    cell.type = ChessTypeNoChess;
    return cell;
}

#pragma mark - other
- (void)judge:(NSIndexPath *)indexPath {
    [JudgeUtil judge:indexPath typeForIndexPath:^ChessType(NSIndexPath *indexPath) {
        ChessCell *cell = (ChessCell *)[self.chessBoard cellForItemAtIndexPath:indexPath];
        return cell.type;
    } result:^(BOOL isWin, NSString *msg) {
        if (isWin) {
            if (self.blackTurn) {
                self.tips.text = [NSString stringWithFormat:@"白赢\n%@", msg];
            } else {
                self.tips.text = [NSString stringWithFormat:@"黑赢\n%@", msg];
            }
        }
    }];
}

@end
