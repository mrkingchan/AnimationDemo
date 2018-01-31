//
//  GroupCell.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "GroupCell.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface GroupCell(){
    UIImageView *_imageView;
    UILabel *_des;
}

@end
@implementation GroupCell

#pragma mark --initialize Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self addSubview:_imageView];
        
        _des = [[UILabel alloc] initWithFrame:CGRectMake(120,35 , [UIScreen mainScreen].bounds.size.width - 120, 30)];
        _des.textColor = [UIColor blackColor];
        _des.textAlignment = 1;
        _des.font = [UIFont systemFontOfSize:15];
        [self addSubview:_des];
        
    }
    return self;
}

- (void)setCellWithData:(id)model{
    if ([model isKindOfClass:[ALAssetsGroup  class]]) {
        ALAssetsGroup *group = (ALAssetsGroup*)model;
        CGImageRef ref = [group posterImage];
        _imageView.image = [UIImage imageWithCGImage:ref];
//        [[group valueForProperty:ALAssetsGroupPropertyType] isEqualToString:ALAssetTypeVideo] ? @"Video":@"Common";
        NSNumber *type = [group valueForProperty:ALAssetsGroupPropertyType];
        NSString *typeStr = @"";
        NSString *desStr;
        switch ([type integerValue]) {
            case 1:
                typeStr = @"ALAssetsGroupLibrary";
                desStr = @"相册";
                break;
            case 2:
                typeStr = @"ALAssetsGroupAlbum";
                desStr = @"相册";
                break;
            case 4:
                typeStr = @"ALAssetsGroupEvent";
                desStr = @"事件";
                break;
            case 8:
                typeStr = @"ALAssetsGroupFaces";
                desStr = @"自拍";
                break;
            case 16:
                typeStr = @"ALAssetsGroupSavedPhotos";
                desStr = @"保存";
                break;
            case 32:
                typeStr = @"ALAssetsGroupPhotoStream";
                desStr = @"照片流";
                break;
            default:
                typeStr = @"ALAssetsGroupAll";
                break;
        }
        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
        _des.text = [NSString stringWithFormat:@"count:%zd,type:%@,name:%@",group.numberOfAssets,desStr,name];
    }
}

@end
