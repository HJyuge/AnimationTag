//
//  HJTagsView.m
//  HJTreeTag
//
//  Created by DaCang on 2017/12/6.
//  Copyright © 2017年 SpeakNow. All rights reserved.
//

#import "HJTagsView.h"
CGFloat const kTextFontSize = 12.0f;
CGFloat const kTextLayerHorizontalPadding = 10.0f;//与底线左右两端的水平距离
CGFloat const kTextLayerVerticalPadding = 5.0f;//与下方底线的垂直距离
CGFloat const kSmallUnderLineLayerRadius = 18.0f;//底线从圆心伸延的长度
CGFloat const kUnderLineLayerRadius = 25.0f;//底线从圆心伸延的长度
CGFloat const kCenterPointRadius = 3.0f;//实心半径
CGFloat const kShadowPointRadius = 6.0f;//阴影半径

NSString *const kAnimationKeyShow = @"show";
NSString *const kAnimationKeyHide = @"hide";

@interface HJTagsView (){
    CGFloat kRoundRadius;
    BOOL  isChangeTagStyle;
}

//tag文字的TextLayer
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *textLayers;
//文字下的横线
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *underLineLayers;
//中心点
@property (nonatomic, strong) CAShapeLayer *centerPointShapeLayer;
@property (nonatomic, strong) CAShapeLayer *shadowPointShapeLayer;

@property (nonatomic, strong) HJTagModel *tagModel;

//标签文本bound
@property (nonatomic, strong) NSMutableArray *textSizeArray;
//标签文本位置
@property (nonatomic, strong) NSMutableArray *textPointArray;

//拖动时的起始位置
@property (nonatomic, assign) CGPoint startPosition;


@end

@implementation HJTagsView
#pragma mark - init初始化
- (instancetype)initWithTagModel:(HJTagModel *)tagModel{
    self = [super init];
    if (self) {
        
        _textLayers = [@[] mutableCopy];
        _underLineLayers = [@[] mutableCopy];
        _textSizeArray = [@[] mutableCopy];
        _textPointArray = [@[] mutableCopy];
        _tagModel = tagModel;
        if (_tagModel.tagContentCount >2) {
            kRoundRadius = kUnderLineLayerRadius;
        }else{
            kRoundRadius = kSmallUnderLineLayerRadius;
        }
        [self setTagsViewFrame];
        [self setupGesture];
        [self setUpUI];
    }
    return self;
}

- (void)setTagsViewFrame {
    CGSize textMaxSize = CGSizeZero;
    for (NSString *content in _tagModel.tagContentsArray) {
        UIFont *font = [UIFont systemFontOfSize:kTextFontSize];
        CGSize textSize = [content sizeWithAttributes:@{NSFontAttributeName:font}];
        NSString *size = NSStringFromCGSize(textSize);
        [_textSizeArray addObject:size];
        if(textSize.width > textMaxSize.width){
            textMaxSize = textSize;
        }
    }
    //控件的宽度 = 2*(斜线的半径+最大文本宽度+文本左边距+文本右边距+控件内边距)
    //控件的高度 =2*(斜线的半径+最大文本的高度+文本的上边距+文本的底边距+控件的内边距)+ 线的厚度*1/2/3
    CGFloat width = (kUnderLineLayerRadius + kTextLayerHorizontalPadding + textMaxSize.width)*2;
    CGFloat height = (kUnderLineLayerRadius + kTextLayerVerticalPadding + textMaxSize.height)*2;
    self.frame = CGRectMake(0, 0, width, height);
}

#pragma mark - UI
- (void)setUpUI {
    _showtagsView = YES;
    //切换风格的时候清空
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_textLayers removeAllObjects];
    [_underLineLayers removeAllObjects];
    [_textPointArray removeAllObjects];
    _centerPointShapeLayer = nil;
    _shadowPointShapeLayer = nil;
    
    //文字TextLayer
    NSInteger index = 0;
    for (NSString *content in _tagModel.tagContentsArray) {
        //设置文本TextLayer
        CATextLayer *textLayer = [self setUpTextLayerWithContent:content];
        [_textLayers addObject:textLayer];
        //下划线
        NSNumber *angle = _tagModel.tagAngleArray[index];
        CGSize textSize = CGSizeFromString(_textSizeArray[index]);
        CAShapeLayer *underLineLayer = [self setupUnderlineShapeLayerWithAngle:angle.doubleValue textSize:textSize];
        [_underLineLayers addObject:underLineLayer];
        //最后设置文本位置
        textLayer.position = CGPointFromString(_textPointArray[index]);
        
        [self.layer addSublayer:textLayer];
        [self.layer addSublayer:underLineLayer];
        index ++ ;
    }
    
    //原点阴影
    _shadowPointShapeLayer = [self setupCenterPointShapeLayerWithRadius:kShadowPointRadius];
    // _shadowPointShapeLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _shadowPointShapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:_shadowPointShapeLayer];
    _shadowPointShapeLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    _shadowPointShapeLayer.shadowOpacity = 1;
    _shadowPointShapeLayer.shadowRadius = 1;
    _shadowPointShapeLayer.shadowOffset = CGSizeMake(0, 0);
    //原点
    _centerPointShapeLayer = [self setupCenterPointShapeLayerWithRadius:kCenterPointRadius];
    [self.layer addSublayer:_centerPointShapeLayer];
}

- (CAShapeLayer *)setupCenterPointShapeLayerWithRadius:(CGFloat)kCenterPointRadius{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kCenterPointRadius*2, kCenterPointRadius*2)].CGPath;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.bounds = CGRectMake(0, 0, kCenterPointRadius*2, kCenterPointRadius*2);
    shapeLayer.position = CGPointMake(self.layer.bounds.size.width/2, self.layer.bounds.size.height/2);
    // shapeLayer.opacity = 0;
    return shapeLayer;
}

- (CAShapeLayer *)setupUnderlineShapeLayerWithAngle:(CGFloat )angle textSize:(CGSize)textSize{
    
    CGPoint centerPoint = CGPointMake(self.layer.bounds.size.width/2, self.layer.bounds.size.height/2);
    CGPoint startPoint = centerPoint;
    CGPoint endPoint;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    lineLayer.shadowOpacity = 0.8;
    lineLayer.shadowRadius = 2;
    lineLayer.shadowOffset = CGSizeMake(0, 0);
    lineLayer.masksToBounds = NO;
    
    //绘制路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:centerPoint];
    
    //圆弧
    if(!(angle == 180.f || angle == -180.f || angle == 0)){
        CGPoint roundPoint = [self arcPointWithCenter:centerPoint radius:kRoundRadius angle:angle];
        [path addLineToPoint:roundPoint];
        startPoint = roundPoint;
    }
    //直线
    if(angle < 90.f && angle > -90.f){
        //角度在第一四象限，向右画
        endPoint = CGPointMake(startPoint.x+textSize.width  + kTextLayerHorizontalPadding, startPoint.y);
        [path addLineToPoint:endPoint];
    }else{
        //角度在第二三象限，向左画
        endPoint = CGPointMake(startPoint.x-textSize.width  - kTextLayerHorizontalPadding, startPoint.y);
        [path addLineToPoint:endPoint];
    }
    
    lineLayer.path = path.CGPath;
    //添加这句话不显示阴影
    //lineLayer.shadowPath = path.CGPath;
    lineLayer.strokeEnd = 0;
    //文本位置
    CGFloat textPositionX = (startPoint.x + endPoint.x)/2 ;
    CGFloat textPositionY = endPoint.y-kTextLayerVerticalPadding-textSize.height/2;
    CGPoint textPoint = CGPointMake(textPositionX, textPositionY);
    [_textPointArray addObject:NSStringFromCGPoint(textPoint)];
    return lineLayer;
}

//根据角度计算圆上某点坐标
- (CGPoint)arcPointWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius angle:(CGFloat)angle {
    
    CGFloat x,y;
    CGFloat newRadius = (angle/180.0) * M_PI;
    //cos  sin  参数是弧度
    x = centerPoint.x + cos(newRadius)*radius;
    y = centerPoint.y + sin(newRadius)*radius;
    //四舍五入
    return CGPointMake(roundf(x), roundf(y));
}

- (CATextLayer *)setUpTextLayerWithContent:(NSString *)content{
    //设置文本大小，颜色，分辨率，阴影，内容
    CATextLayer *textLayer = [CATextLayer layer];
    UIFont *font = [UIFont systemFontOfSize:kTextFontSize];
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.opacity = 0;
    textLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    textLayer.shadowOpacity = 0.8;
    textLayer.shadowRadius = 2;
    textLayer.shadowOffset = CGSizeMake(0, 0);
    textLayer.string = content;
    CGSize textSize = [textLayer preferredFrameSize];
    textLayer.bounds = CGRectMake(0, 0, textSize.width, textSize.height);
    return textLayer;
}
#pragma mark - Interaction
//添加手势
- (void)setupGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:longPressGesture];
    [self addGestureRecognizer:panGesture];
}
//点击
- (void)didTap:(UITapGestureRecognizer *)recognizer {
    //非编辑状态
    if (_editDisable == YES || _showtagsView == NO) {
        return;
    }
    
    CGPoint position = [recognizer locationInView:self];
    //点击文本
    if(_textDidTapBlock){
        _textDidTapBlock(self);
        return;
    }
    //点击圆心
    //判断点触范围是否在延展中心圆范围
    if ([self centerContainsPoint:position]) {
        //切换风格
        isChangeTagStyle = YES;
        [_tagModel changeTagViewStyle];
        [self setUpUI];
        self.showtagsView = YES;
        
        if(_textDidTapBlock){
            _textDidTapBlock(self);
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    //非编辑状态
    if (_editDisable == YES || _showtagsView == NO) {
        return;
    }
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            CGPoint position = [recognizer locationInView:self];
            if ([self centerContainsPoint:position] || [self textLayerContainsPoint:position]) {
                if(_longPressBlock){
                    _longPressBlock(self);
                    return;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
            break;
        }
        default:
            break;
    }
    
}

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
    //非编辑状态
    if (_editDisable == YES || _showtagsView == NO) {
        return;
    }
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan:{
            //保存初始点击位置
            _startPosition = [recognizer locationInView:self.superview];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            //移动
            CGPoint position = [recognizer locationInView:self.superview];
            self.center = position;
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
            //最后保存中心点的相对坐标
            CGFloat x,y;
            x = self.center.x/self.superview.bounds.size.width;
            y = self.center.y/self.superview.bounds.size.height;
            CGPoint coordinate = CGPointMake(x, y);
            _tagModel.coordinate = coordinate;
            break;
        }
        default:
            break;
    }
}

//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    return view;
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //不在中心圆范围不处理
    if (![self centerContainsPoint:point] || ![self textLayerContainsPoint:point]) {
        return NO;
    }
    
    return [super pointInside:point withEvent:event];
}

//隐藏或动画中不响应
//点position是否在半径为kUnderLineLayerRadius的中心圆内
- (BOOL)centerContainsPoint:(CGPoint)position {
    CGPoint centerPosition = CGPointMake(self.layer.bounds.size.width/2, self.layer.bounds.size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPosition radius:kUnderLineLayerRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    return [path containsPoint:position];
}

- (BOOL)textLayerContainsPoint:(CGPoint)position {
    for (CATextLayer *textLayer in _textLayers) {
        if(textLayer.presentationLayer.opacity == 0){
            continue;
        }
        return YES;
    }
    return NO;
}

- (void)showTagsViewWithAnimated:(BOOL)animated{
    
    CGFloat duration = 0.3f;
    [self animateWithDuration:3*duration AnimationBlock:^{
        NSTimeInterval currentTime = CACurrentMediaTime();
        CAAnimationGroup *animationGrop = [CAAnimationGroup animation];
        animationGrop.removedOnCompletion = NO;
        animationGrop.duration = 1;
        animationGrop.fillMode = kCAFillModeForwards;
        //相同时间只执行一个动画
        //原点
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.beginTime = 0;
        basicAnimation.keyPath = @"opacity";
        basicAnimation.duration = duration;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.fillMode = kCAFillModeForwards;
        basicAnimation.fromValue = @0;
        basicAnimation.toValue = @1;
        
        if (isChangeTagStyle ==YES) {
            
            CAKeyframeAnimation *scaleKeyframeAnimation = [CAKeyframeAnimation animation];
            scaleKeyframeAnimation.beginTime = duration;
            scaleKeyframeAnimation.keyPath = @"transform.scale";
            scaleKeyframeAnimation.keyTimes = @[@0, @0.2, @0.4];
            scaleKeyframeAnimation.values = @[@1, @1.5, @1];
            animationGrop.animations = @[basicAnimation,scaleKeyframeAnimation];
        }else{
            animationGrop.animations = @[basicAnimation];
        }
        [_centerPointShapeLayer addAnimation:animationGrop forKey:kAnimationKeyShow];
        [_shadowPointShapeLayer addAnimation:animationGrop forKey:kAnimationKeyShow];
        
        //下划线
        CABasicAnimation *lineAnimation = [CABasicAnimation animation];
        lineAnimation.beginTime = currentTime+duration;
        lineAnimation.keyPath = @"strokeEnd";
        lineAnimation.duration = duration;
        lineAnimation.removedOnCompletion = NO;
        lineAnimation.fillMode = kCAFillModeBoth;
        lineAnimation.fromValue = @0;
        lineAnimation.toValue = @1;
        for (CAShapeLayer *shapeLayer in _underLineLayers) {
            [shapeLayer addAnimation:lineAnimation forKey:kAnimationKeyShow];
        }
        
        //文字
        CABasicAnimation *textAnimation = [CABasicAnimation animation];
        textAnimation.beginTime = currentTime+duration*2;
        textAnimation.keyPath = @"opacity";
        textAnimation.duration = duration;
        textAnimation.removedOnCompletion = NO;
        textAnimation.fillMode = kCAFillModeBoth;
        textAnimation.fromValue = @0;
        textAnimation.toValue = @1;
        for(CATextLayer *textLayer in _textLayers){
            [textLayer addAnimation:textAnimation forKey:kAnimationKeyShow];
        }
        
    } completeBlock:^{
        isChangeTagStyle = NO;
        _hiddenTagView = NO;
    }];
    
}


- (void)hideTagsViewWithAnimated:(BOOL)animated {
    
    CGFloat duration = 0.3f;
    [self animateWithDuration:3*duration AnimationBlock:^{
        //原点
        NSTimeInterval currentTime = CACurrentMediaTime();
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.beginTime = 0;
        basicAnimation.keyPath = @"opacity";
        basicAnimation.duration = duration;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.fillMode = kCAFillModeForwards;
        basicAnimation.fromValue = @1;
        basicAnimation.toValue = @0;
        [_centerPointShapeLayer addAnimation:basicAnimation forKey:kAnimationKeyShow];
        [_shadowPointShapeLayer addAnimation:basicAnimation forKey:kAnimationKeyShow];
        
        //下划线
        CABasicAnimation *lineAnimation = [CABasicAnimation animation];
        lineAnimation.beginTime = currentTime+duration;
        lineAnimation.keyPath = @"strokeEnd";
        lineAnimation.duration = duration;
        lineAnimation.removedOnCompletion = NO;
        lineAnimation.fillMode = kCAFillModeBoth;
        lineAnimation.fromValue = @1;
        lineAnimation.toValue = @0;
        for (CAShapeLayer *shapeLayer in _underLineLayers) {
            [shapeLayer addAnimation:lineAnimation forKey:kAnimationKeyShow];
        }
        
        //文字
        CABasicAnimation *textAnimation = [CABasicAnimation animation];
        textAnimation.beginTime = currentTime+duration*2;
        textAnimation.keyPath = @"opacity";
        textAnimation.duration = duration;
        textAnimation.removedOnCompletion = NO;
        textAnimation.fillMode = kCAFillModeBoth;
        textAnimation.fromValue = @1;
        textAnimation.toValue = @0;
        for(CATextLayer *textLayer in _textLayers){
            [textLayer addAnimation:textAnimation forKey:kAnimationKeyShow];
        }
        
    } completeBlock:^{
        _hiddenTagView = YES;
    }];
}

- (void)animateWithDuration:(CGFloat)duration
             AnimationBlock:(void(^)())doBlock
              completeBlock:(void(^)())completeBlock{
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    //具体动画
    if(doBlock){
        doBlock();
    }
    //
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (completeBlock) {
            completeBlock();
        }
        [CATransaction commit];
    }];
    
    [CATransaction commit];
}

#pragma mark - Other
- (void)setEditDisable:(BOOL)editDisable {
    _editDisable = editDisable;
    
}

- (void)setShowtagsView:(BOOL)showtagsView {
    _showtagsView = showtagsView;
    
    if (showtagsView) {
        [self showTagsViewWithAnimated:YES];
    }else{
        [self hideTagsViewWithAnimated:NO];
    }
}
@end

