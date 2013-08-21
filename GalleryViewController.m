//
//  GalleryViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "GalleryViewController.h"
#import "MBProgressHUD.h"
#import "SendViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Gallery";
//    [self.navigationController setNavigationBarHidden:NO];
    
    [self getAllPictures];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
static int count = 0;
#pragma mark - General
- (void)getAllPictures{
    _imageArray=[[NSArray alloc] init];
    _mutableArray =[[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];

    _library = [[ALAssetsLibrary alloc] init];

    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                [_library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]],@"image",url,@"path" , nil] ;
//                             [_mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             [_mutableArray addObject:dict];
                             
                             if ([_mutableArray count]==count)
                             {
                                 _imageArray=[[NSArray alloc] initWithArray:_mutableArray];
                                 [self allPhotosCollected:_imageArray];
                             }
                         }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };

    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];

    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count=[group numberOfAssets];
        }
    };

    assetGroups = [[NSMutableArray alloc] init];

    [_library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}

-(void)allPhotosCollected:(NSArray*)imgArray
{
    //write your code here after getting all the photos from library...
    NSLog(@"all pictures are %@",imgArray);
    if(_resultArray != nil){
        [_resultArray removeAllObjects];
        [_resultArray addObject:imgArray];
    }else{
        _resultArray = [NSMutableArray arrayWithArray:imgArray];
    }
    
    [self.galleryView layoutSubviews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/************************************************************************/
/*																		*/
/*	FlowCover Callbacks													*/
/*																		*/
/************************************************************************/

- (int)flowCoverNumberImages:(FlowCoverView *)view
{
	return [_resultArray count];
}

- (UIImage *)flowCover:(FlowCoverView *)view cover:(int)image
{
    NSDictionary *dict = [_resultArray objectAtIndex:image];
    return [dict objectForKey:@"image"];
}

- (void)flowCover:(FlowCoverView *)view didSelect:(int)image
{
	NSLog(@"Selected Index %d",image);
    SendViewController *sendViewController = [[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil];
    [sendViewController setSourceType:@"Gallery"];
    [sendViewController setMsgAsset:[_resultArray objectAtIndex:image]];
    
    [self.navigationController pushViewController:sendViewController animated:YES];
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
