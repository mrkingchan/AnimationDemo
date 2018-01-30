//
//  PhotoCell.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoCell(){
    UIImageView *_imageView;
    UIImageView *_video;
}

@end
@implementation PhotoCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        
        _video = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2.0 - 20, self.bounds.size.height / 2.0 - 20, 40, 40)];
        [_video setImage:[UIImage imageNamed:@"video"]];
        [self addSubview:_video];
        _video.hidden = YES;
    }
    return self;
}

- (void)setCellWithData:(id)image {
    if ([image isKindOfClass:[ALAsset class]]) {
        //ALAsset
        CGImageRef  thumbnailRef = [((ALAsset *) image) thumbnail];
        UIImage *thumbnailImg = [[UIImage alloc]initWithCGImage:thumbnailRef];
        [_imageView setImage:thumbnailImg];
        id type = [((ALAsset *)image) valueForProperty:ALAssetPropertyType];
        if ([type isEqualToString:ALAssetTypeVideo]) {
            _video.hidden = NO;
        } else {
            _video.hidden = YES;
        }
    }
}
@end


