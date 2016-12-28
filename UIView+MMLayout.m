

#import "UIView+MMLayout.h"
#import <objc/runtime.h>
@implementation UIView (MM)
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void)setW:(CGFloat)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}
- (CGFloat)w{
    return self.frame.size.width;
}
- (void)setH:(CGFloat)h{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}
- (CGFloat)h{
    return self.frame.size.height;
}
-(CGFloat)centerX{
    return self.center.x;
}
-(CGFloat)centerY{
    return self.center.y;
}
- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}
- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}
- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}
- (CGFloat)halfW{
    return self.w / 2;
}
- (CGFloat)halfH{
    return self.h / 2;
}
- (CGFloat)halfX{
    return self.x / 2;
}
- (CGFloat)halfY{
    return self.y / 2;
}
-(CGFloat)halfCenterX{
    return self.centerX / 2;
}
-(CGFloat)halfCenterY{
   return self.centerY / 2;
}
-(CGSize)mm_size{
    return self.bounds.size;
}

@end
@interface MMLayout()
@property (copy   , nonatomic) void(^updateChangeBlock)(CGRect frame);
@property (weak   , nonatomic) UIView *layoutView;
@end

@implementation MMLayout
-(instancetype)initWithLayoutView:(UIView *)LayoutView{
    if (self=[super init]) {
        self.layoutView = LayoutView;
    }
    return self;
}
-(void)setLeft:(CGFloat)left{
    _left = left;
    self.layoutView.x = left;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);
}
-(void)setTop:(CGFloat)top{
    _top = top;
    self.layoutView.y = top;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);
}
-(void)setRight:(CGFloat)right{
    _right = right;
   UIView *superview = self.layoutView.superview;
    self.layoutView.x = superview.w - self.layoutView.w - right;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);
}

-(void)setBottom:(CGFloat)bottom{
    _bottom = bottom;
    UIView *superview = self.layoutView.superview;
    self.layoutView.y =  superview.h - self.layoutView.h - bottom;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);
}

-(void)setHeight:(CGFloat)height{
    _height = height;
    self.layoutView.h  = height;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);
}
-(void)setWidth:(CGFloat)width{
    _width = width;
    self.layoutView.w = width;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);
}
-(void)setSize:(CGSize )size{
    self.layoutView.w = size.width;
    self.layoutView.h = size.height;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);

}
-(void)center{
    UIView *superview = self.layoutView.superview;
    self.layoutView.x = superview.halfW - self.layoutView.halfW;
    self.layoutView.y = superview.halfH - self.layoutView.halfH;
    !self.updateChangeBlock ? : self.updateChangeBlock(self.layoutView.frame);
    
}
@end
const void *_layoutKey;
@implementation UIView (Layout)
-(void)make_LayoutUpdateChange:(void (^)(CGRect))block{
    [self mm_selfLayout].updateChangeBlock = block;
}

-(void)make_Layout:(void (^)(MMLayout *))layout{
    if (layout) {
        MMLayout *mm_Layout = [[MMLayout alloc] initWithLayoutView:self];
        layout(mm_Layout);
    }
}

- (MMLayout *)mm_selfLayout{
    MMLayout *layout = objc_getAssociatedObject(self, &_layoutKey);
    if (layout == nil) {
        layout = [[MMLayout alloc] initWithLayoutView:self];
        objc_setAssociatedObject(self, &_layoutKey, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return layout;
}

-(UIView *(^)(CGFloat))m_top{
    __weak typeof(self)_self = self;
    return ^(CGFloat m_top){
        __strong typeof(_self)self = _self;
        [self mm_selfLayout].top = m_top;
           return self;
    };
}
-(UIView *(^)(CGFloat))m_bottom{
    __weak typeof(self)_self = self;
    return ^(CGFloat m_bottom){
        __strong typeof(_self)self = _self;
        [self mm_selfLayout].bottom = m_bottom;
        return self;
    };
}


-(UIView *(^)(CGFloat))m_left{
    __weak typeof(self)_self = self;
    return ^(CGFloat m_left){
        __strong typeof(_self)self = _self;
        [self mm_selfLayout].left = m_left;
        return self;
    };
}


-(UIView *(^)(CGFloat))m_right{
    __weak typeof(self)_self = self;
    return ^(CGFloat m_right){
        __strong typeof(_self)self = _self;
        [self mm_selfLayout].right = m_right;
        return self;
    };
}
-(UIView *(^)(CGFloat))m_width{
    __weak typeof(self)_self = self;
    return ^(CGFloat m_width){
        __strong typeof(_self)self = _self;
        [self mm_selfLayout].width = m_width;
        return self;
    };
}
-(UIView *(^)(CGFloat))m_height{
    __weak typeof(self)_self = self;
    return ^(CGFloat m_height){
        __strong typeof(_self)self = _self;
        [self mm_selfLayout].height = m_height;
        return self;
    };
}
-(UIView *(^)(CGSize))m_size{
    __weak typeof(self)_self = self;
    return ^(CGSize m_size){
        __strong typeof(_self)self = _self;
        [self mm_selfLayout].size = m_size;
        return self;
    };
}
-(UIView *(^)())m_center{
    __weak typeof(self)_self  = self;
    return ^{
        __strong typeof(_self)self = _self;
        [[self mm_selfLayout] center];
        return self;
    };
}
@end



