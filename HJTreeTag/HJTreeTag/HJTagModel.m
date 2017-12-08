//
//  HJTagModel.m
//  HJTreeTag
//
//  Created by DaCang on 2017/12/6.
//  Copyright © 2017年 SpeakNow. All rights reserved.
//

#import "HJTagModel.h"

static NSInteger const maxStyle = 4;

@interface HJTagModel ()

@end

@implementation HJTagModel
- (instancetype)initTagModelWithTagContentsArray:(NSMutableArray *)tagContentsArray tagStyle:(TagViewStyle)tagStyle coordinate:(CGPoint)coordinate {
    
    self = [super init];
    if (self) {
        self.tagContentsArray = tagContentsArray;
        self.tagStyle = tagStyle;
        self.coordinate = coordinate;
        _tagContentCount = tagContentsArray.count;
        _tagAngleArray = [@[] mutableCopy];
        [self setTagAngle];
    }
    return self;
}

- (void)changeTagViewStyle {
    _tagStyle = (_tagStyle+1)%maxStyle;
    [self setTagAngle];
}

- (void)setTagAngle {
    NSMutableArray *angleArray = [@[] mutableCopy];
    if (_tagContentCount == 1) {
        if (_tagStyle == TagViewStyleStraightRight) {
            [angleArray addObject:@0.0];
        }else if (_tagStyle == TagViewStyleStraightLeft){
            [angleArray addObject:@(180.0)];
        }else if (_tagStyle == TagViewStyleObliqueRight){
            [angleArray addObject:@45.0];
        }else if (_tagStyle == TagViewStyleObliqueLeft){
            [angleArray addObject:@(135.0)];
        }
    }else if(_tagContentCount == 2){
        if (_tagStyle == TagViewStyleStraightRight) {
            
            [angleArray addObjectsFromArray:@[@(-89.99),@89.99]];
        }else if (_tagStyle == TagViewStyleStraightLeft){
            [angleArray addObjectsFromArray:@[@(-90.11),@(90.11)]];
        }else if (_tagStyle == TagViewStyleObliqueRight){
            [angleArray addObjectsFromArray:@[@(-45.0),@45.0]];
        }else if (_tagStyle == TagViewStyleObliqueLeft){
            [angleArray addObjectsFromArray:@[@(-135.0),@(135.0)]];
        }
    }else if(_tagContentCount == 3){
        if (_tagStyle == TagViewStyleStraightRight) {
            [angleArray addObjectsFromArray:@[@(-89.99),@0.0,@89.99]];
        }else if (_tagStyle == TagViewStyleStraightLeft){
            [angleArray addObjectsFromArray:@[@(-90.11),@(180.0),@(90.11)]];
        }else if (_tagStyle == TagViewStyleObliqueRight){
            [angleArray addObjectsFromArray:@[@(-45.0),@45.0,@(135.0)]];
            
        }else if (_tagStyle == TagViewStyleObliqueLeft){
            [angleArray addObjectsFromArray:@[@(-135.0),@(45.0),@135.0]];
        }
    }
    _tagAngleArray = angleArray;
}
@end
