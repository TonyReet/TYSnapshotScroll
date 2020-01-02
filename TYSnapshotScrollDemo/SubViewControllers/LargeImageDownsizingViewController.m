#import "LargeImageDownsizingViewController.h"
#import <QuartzCore/QuartzCore.h>


#define kImageFilename @"large_leaves_80mp.png"//@"large_leaves_70mp.jpg" // 7033x10110 image, 271 MB uncompressed


#   define kDestImageSizeMB 120.0f // The resulting image will be (x)MB of uncompressed image data. 
#   define kSourceImageTileSizeMB 40.0f // The tile size will be (x)MB of uncompressed image data. 

#define bytesPerMB 1048576.0f 
#define bytesPerPixel 4.0f
#define pixelsPerMB ( bytesPerMB / bytesPerPixel ) // 262144 pixels, for 4 bytes per pixel.
#define destTotalPixels kDestImageSizeMB * pixelsPerMB
#define tileTotalPixels kSourceImageTileSizeMB * pixelsPerMB
#define destSeemOverlap 2.0f // the numbers of pixels to overlap the seems where tiles meet.

@implementation LargeImageDownsizingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //--
    self.progressView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.progressView];
    self.progressView.backgroundColor = [UIColor redColor];
    [NSThread detachNewThreadSelector:@selector(downsize) toTarget:self withObject:nil];
//    [self downsize];
}

-(void)downsize{
    @autoreleasepool {

    self.sourceImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kImageFilename ofType:nil]];
    if( self.sourceImage == nil ) NSLog(@"input image not found!");

    CGSize sourceResolution;
    CGSize destResolution;
    CGRect sourceTile;
    CGRect destTile;
        
    sourceResolution.width = CGImageGetWidth(self.sourceImage.CGImage);
    sourceResolution.height = CGImageGetHeight(self.sourceImage.CGImage);
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

        sourceTileImageRef = CGImageCreateWithImageInRect( self.sourceImage.CGImage, sourceTile );

        if( y == iterations - 1 && remainder ) {
            float dify = destTile.size.height;
            destTile.size.height = CGImageGetHeight( sourceTileImageRef ) * self.imageScale;
            dify -= destTile.size.height;
            destTile.origin.y += dify;
        }

        CGContextDrawImage( self.destContext, destTile, sourceTileImageRef );

        CGImageRelease( sourceTileImageRef ); 

        self.sourceImage = nil;
            
        }
    
        if( y < iterations - 1 ) {            
            self.sourceImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kImageFilename ofType:nil]];
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
    self.progressView.image = self.destImage;
}

-(void)initializeScrollView{
    [self createImageFromContext];
}

@end
