//
//  HJTagModel.h
//  HJTreeTag
//
//  Created by DaCang on 2017/12/6.
//  Copyright © 2017年 SpeakNow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger ,TagViewStyle) {
    TagViewStyleStraightRight = 0,
    TagViewStyleStraightLeft,
    TagViewStyleObliqueRight,
    TagViewStyleObliqueLeft
};

@interface HJTagModel : NSObject

/** 圆心坐标 */
@property (nonatomic, assign)CGPoint coordinate;
/** 标签风格 */
@property (nonatomic, assign)TagViewStyle tagStyle;
/** 标签文本 */
@property (nonatomic, strong)NSMutableArray *tagContentsArray;
/** 标签数量 */
@property (nonatomic, assign,readonly)NSInteger tagContentCount;
/** 标签角度 */
@property (nonatomic, strong,readonly)NSMutableArray *tagAngleArray;



- (instancetype)initTagModelWithTagContentsArray:(NSMutableArray *)tagContentsArray tagStyle:(TagViewStyle)tagStyle coordinate:(CGPoint )coordinate;

- (void)changeTagViewStyle;

@end

