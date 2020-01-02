//
//  PreviewVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/11/24.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "PreviewVc.h"

#define kImageFilename @"large_leaves_80mp.png"//@"large_leaves_70mp.jpg" // 7033x10110 image, 271 MB uncompressed


#   define kDestImageSizeMB 120.0f // The resulting image will be (x)MB of uncompressed image data.
#   define kSourceImageTileSizeMB 40.0f // The tile size will be (x)MB of uncompressed image data.

#define bytesPerMB 1048576.0f
#define bytesPerPixel 4.0f
#define pixelsPerMB ( bytesPerMB / bytesPerPixel ) // 262144 pixels, for 4 bytes per pixel.
#define destTotalPixels kDestImageSizeMB * pixelsPerMB
#define tileTotalPixels kSourceImageTileSizeMB * pixelsPerMB
#define destSeemOverlap 2.0f // the numbers of pixels to overlap the seems where tiles meet.


@interface PreviewVc ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) UIImage *destImage;

@property (nonatomic,assign) CGRect sourceTile;

@property (nonatomic,assign) CGRect destTile;

@property (nonatomic,assign) CGFloat imageScale;

@property (nonatomic,assign) CGSize sourceResolution;

@property (nonatomic,assign) CGFloat sourceTotalPixels;

@property (nonatomic,assign) CGFloat sourceTotalMB;

@property (nonatomic,assign) CGSize destResolution;

@property (nonatomic,assign) CGContextRef destContext;

@property (nonatomic,assign) CGFloat sourceSeemOverlap;

@end

@implementation PreviewVc


- (instancetype)init:(UIImage *)image
{
    self = [super init]; //用于初始化父类
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self adjustsScrollViewInset];
    
    [self initView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存截图" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)];
}
- (void)adjustsScrollViewInset{
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView = [UIScrollView new];
    
    [self.scrollView addSubview:self.imageView];

    [self.view addSubview:self.scrollView];

    CGRect scrollViewFrame = self.view.bounds;
    scrollViewFrame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.scrollView.frame = scrollViewFrame;
    
    CGFloat height =  self.image.size.height;
    CGFloat width =  self.image.size.width;
    self.scrollView.contentSize = CGSizeMake(width, height);
    self.imageView.frame = CGRectMake(0, 0, width, height);

//    [NSThread detachNewThreadSelector:@selector(downsize) toTarget:self withObject:nil];
}

- (void)saveImage{
    //save to photosAlbum
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *barItemTitle = @"保存成功";
    if (error != nil) {
        barItemTitle = @"保存失败";
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:barItemTitle];
}

-(void)downsize{
    @autoreleasepool {

    self.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kImageFilename ofType:nil]];
    if( self.image == nil ) NSLog(@"input image not found!");

    CGSize sourceResolution;
    CGSize destResolution;
    CGRect sourceTile;
    CGRect destTile;
        
    sourceResolution.width = CGImageGetWidth(self.image.CGImage);
    sourceResolution.height = CGImageGetHeight(self.image.CGImage);
    self.sourceResolution = sourceResolution;
        
    self.sourceTotalPixels = sourceResolution.width * sourceResolution.height;

    self.sourceTotalMB = self.sourceTotalPixels / pixelsPerMB;

    self.imageScale = destTotalPixels / self.sourceTotalPixels;

    destResolution.width = (int)( sourceResolution.width * self.imageScale );
    destResolution.height = (int)( sourceResolution.height * self.imageScale );
    self.destResolution = destResolution;
        
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerRow = bytesPerPixel * destResolution.width;

    void* destBitmapData = malloc( bytesPerRow * destResolution.height );
    if( destBitmapData == NULL ) NSLog(@"failed to allocate space for the output image!");

    self.destContext = CGBitmapContextCreate( destBitmapData, destResolution.width, destResolution.height, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast );

    if( self.destContext == NULL ) {
        free( destBitmapData );
        NSLog(@"failed to create the output bitmap context!");
    }

    CGColorSpaceRelease( colorSpace );

    CGContextTranslateCTM( self.destContext, 0.0f, destResolution.height );
    CGContextScaleCTM( self.destContext, 1.0f, -1.0f );

        
    sourceTile.size.width = sourceResolution.width;

    sourceTile.size.height = (int)( tileTotalPixels / sourceTile.size.width );
    NSLog(@"source tile size: %f x %f",sourceTile.size.width, sourceTile.size.height);
    sourceTile.origin.x = 0.0f;
    self.sourceTile = sourceTile;
        
    destTile.size.width = destResolution.width;
    destTile.size.height = sourceTile.size.height * self.imageScale;
    destTile.origin.x = 0.0f;
    NSLog(@"dest tile size: %f x %f",destTile.size.width, destTile.size.height);

    self.sourceSeemOverlap = (int)( ( destSeemOverlap / destResolution.height ) * sourceResolution.height );
    NSLog(@"dest seem overlap: %f, source seem overlap: %f",destSeemOverlap, self.sourceSeemOverlap);
    CGImageRef sourceTileImageRef;

    int iterations = (int)( sourceResolution.height / sourceTile.size.height );

    int remainder = (int)sourceResolution.height % (int)sourceTile.size.height;
    if( remainder ) iterations++;
    
    float sourceTileHeightMinusOverlap = sourceTile.size.height;
    sourceTile.size.height += self.sourceSeemOverlap;
    destTile.size.height += destSeemOverlap;
    NSLog(@"beginning downsize. iterations: %d, tile height: %f, remainder height: %d", iterations, sourceTile.size.height,remainder );
    for( int y = 0; y < iterations; ++y ) {
        @autoreleasepool {
            
        NSLog(@"iteration %d of %d",y+1,iterations);
        sourceTile.origin.y = y * sourceTileHeightMinusOverlap + self.sourceSeemOverlap;
        destTile.origin.y = ( destResolution.height ) - ( ( y + 1 ) * sourceTileHeightMinusOverlap * self.imageScale + destSeemOverlap );

        sourceTileImageRef = CGImageCreateWithImageInRect( self.image.CGImage, sourceTile );

        if( y == iterations - 1 && remainder ) {
            float dify = destTile.size.height;
            destTile.size.height = CGImageGetHeight( sourceTileImageRef ) * self.imageScale;
            dify -= destTile.size.height;
            destTile.origin.y += dify;
        }

        CGContextDrawImage( self.destContext, destTile, sourceTileImageRef );

        CGImageRelease( sourceTileImageRef );

        self.image = nil;
        }
    
        if( y < iterations - 1 ) {
            self.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kImageFilename ofType:nil]];
            [self performSelectorOnMainThread:@selector(updateScrollView) withObject:nil waitUntilDone:YES];
        }
    }
    NSLog(@"downsize complete.");
    [self performSelectorOnMainThread:@selector(initializeScrollView) withObject:nil waitUntilDone:YES];
        
    CGContextRelease( self.destContext );
    }
}

-(void)createImageFromContext {
    CGImageRef destImageRef = CGBitmapContextCreateImage( self.destContext );
    if( destImageRef == NULL ) NSLog(@"destImageRef is null.");
    
    self.destImage = [UIImage imageWithCGImage:destImageRef scale:1.0f orientation:UIImageOrientationDownMirrored];
    
    CGImageRelease( destImageRef );
    if( self.destImage == nil ) NSLog(@"destImage is nil.");
}

-(void)updateScrollView{
    [self createImageFromContext];
    self.imageView.image = self.destImage;
}

-(void)initializeScrollView{
    [self createImageFromContext];
}

@end
