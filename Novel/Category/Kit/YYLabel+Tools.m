//
//  YYLabel+Tools.m
//  Novel
//
//  Created by th on 2017/2/11.
//  Copyright © 2017年 th. All rights reserved.
//

#import "YYLabel+Tools.h"

@implementation YYLabel (Tools)

+ (YYLabel *_Nonnull)labelWithFrame:(CGRect)frame textFont:(CGFloat)font textColor:(UIColor *_Nullable)color {
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:frame];
    
    label.font = FONT_SIZE(font);
    
    label.displaysAsynchronously = YES;
//    label.ignoreCommonProperties = YES;这里不能为yes,因为这里不用textLayout布局
    label.fadeOnHighlight = NO;
    label.fadeOnAsynchronouslyDisplay = NO;

    
    if (!color) {
        label.textColor = kBlackColor;
    } else {
        label.textColor = color;
    }
    
    return label;
}

- (nonnull YYTextLayout *)layoutWithTitle:(nonnull NSString *)title maxSize:(CGSize)maxSize maximumNumberOfRows:(NSUInteger)maximumNumberOfRows textFont:(nonnull UIFont *)font textColor:(nonnull UIColor *)color lineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.font = font;
    text.color = color;
    
    if (lineSpace > 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        
        paragraphStyle.lineSpacing = lineSpace;
        
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    }
    
    YYTextContainer *container = [YYTextContainer containerWithSize:maxSize];
    container.maximumNumberOfRows = maximumNumberOfRows;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    
    return layout;
}

#pragma mark - 计算label中的行数和 每一行的内容
+ (NSArray *)getLinesArrayOfStringInLabel:(YYLabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

@end
