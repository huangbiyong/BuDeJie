//
//  BYSeeBigPictureViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/18.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYSeeBigPictureViewController.h"
#import "BYTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <Photos/Photos.h>

@interface BYSeeBigPictureViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIImageView  *imageView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation BYSeeBigPictureViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view insertSubview:scrollView atIndex:0];
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (!image) return ;
        self.saveButton.enabled = YES;
        
    }];
    imageView.by_width = scrollView.by_width;
    imageView.by_height = imageView.by_width * self.topic.height / self.topic.width;
    imageView.by_x = 0;
    if (imageView.by_height > BYScreenH) {
        imageView.by_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.by_height);
    } else {
        imageView.by_centerY = scrollView.by_height * 0.5;
    }
    [scrollView addSubview:imageView];
    
    self.imageView = imageView;
    
    // 图片缩放
    CGFloat maxScale = self.topic.width / imageView.by_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
 
    /*
       方式一
            c函数方式 UIImageWriteToSavedPhotosAlbum
            配合  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
     */

    //UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    
    /**
        如果用户还没有做出选择，会自动弹出提示框。用户对提示框做出选择后，才会回调block
        如果之前已经做过选择，会直接执行block
     */
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status == PHAuthorizationStatusDenied) {  // 用户拒绝当前app访问相册
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    NSLog(@"提醒用户打开开关");
                }
            } else if (status == PHAuthorizationStatusAuthorized) {  //用户允许
                [self saveImageIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted) {
                [SVProgressHUD showWithStatus:@"系统拒绝访问"];
            }
            
        });
    }];
    
}

/*
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"%s",__func__);
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
    }
}
*/

#pragma mark - 获取当前app对应的自定义相册
- (PHAssetCollection *)createdCollectionAlbum {
    // 获取当前app名
    NSString *appName = [NSBundle mainBundle].infoDictionary[(__bridge NSString*)kCFBundleNameKey];
    
    // 获取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 查找当前app对应的自定义相册
    for (PHAssetCollection * collection in collections) {
        
        // 找到就返回
        if ([collection.localizedTitle isEqualToString:appName]) {
            return collection;
        }
    }
    
    // 没有找到就创建一个当前的自定义相册
    NSError *error = nil;
    __block NSString *localIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        localIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject;
    
}

#pragma mark - 保存图片到 Camera Roll (相机胶卷 -- 系统相册)
- (PHFetchResult<PHAsset *> *)createdAssets {
    
    NSError *error = nil;
    __block NSString *assetId = nil;
    
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil];
}

#pragma mark - 保存图片到相册
/**
   1. 保存图片到 Camera Roll
   2. 获得自定义相册
   3. 添加刚才保存的图片到【自定义相册】
 */

- (void)saveImageIntoAlbum {
    
    // 1. 保存图片到 Camera Roll
    PHFetchResult<PHAsset *> *createdAssets = [self createdAssets];
    if (createdAssets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
        return;
    }
    
    // 2. 获得自定义相册
    PHAssetCollection *createdCollectionAlbum = [self createdCollectionAlbum];
    if (createdCollectionAlbum == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建或者获取相册失败！"];
        return;
    }
    
    // 3. 添加刚才保存的图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        
        // 切换到自定义相册
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollectionAlbum];
        // 插入图片
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&error];
    
    // 判断图片是否保存成功
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }
    
}

@end























