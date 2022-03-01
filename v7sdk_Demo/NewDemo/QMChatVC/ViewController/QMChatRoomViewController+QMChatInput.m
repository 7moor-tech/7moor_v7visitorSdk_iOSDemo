//
//  QMChatRoomViewController+QMChatInput.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/30.
//

#import "QMChatRoomViewController+QMChatInput.h"
#import "QMChatRoomViewController+ChatMessage.h"
#import "QMFileManagerController.h"

@implementation QMChatRoomViewController (QMChatInput)

- (void)textViewDidChange:(NSString *)text {
    
    //预知输入 - 人工下+开启预知输入
    if (self.serviceMode == QMChatServiceModeCustomer && QMThemeManager.shared.isVisitorTypeNotice) {
       [self inputTypeNotice:text];
   }
    
    if (text.length > 0) {
        if (self.isRobot && self.isAssociationInput) {
            [self inputSuggest:text];
        }
    }else {
        self.associationView.hidden = YES;
    }
}

// 预知接口
- (void)inputTypeNotice:(NSString *)text {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [QMConnect sdkInputTypeNotice:text completion:^(NSDictionary * dict) {
        NSLog(@"dict = %@",dict);
    } failure:^(NSError * err) {
        NSLog(@"err = %@",err.localizedDescription);
    }];
}

- (void)textViewDidChangeSelection:(NSString *)text {
    if (text.length == 0) {
        self.associationView.hidden = YES;
        // 发送完后清空输入框后，发送
        [self inputTypeNotice:@""];
    }
}

- (void)textViewDidEndEditing:(NSString *)text {
    self.associationView.hidden = YES;
}

- (void)textViewDidBeginEditing:(NSString *)text  {
    [self.view bringSubviewToFront:self.associationView];
    if (text.length > 0) {
        if (self.isRobot && self.isAssociationInput) {
            [self inputSuggest:text];
        }
    }else {
        self.associationView.hidden = YES;
    }
}

- (void)sendTextViewText:(NSString *)text {
    [self sendTextMessage:text];
    self.associationView.hidden = YES;
}

- (void)sendAudio:(NSString *)audioName duration:(NSString *)duration {
    [self sendAudioMesage:audioName duration:duration];
}

#pragma mark - moreViewDelegate
- (void)moreViewSelectAcitonIndex:(QMChatMoreMode)index {
    switch (index) {
        case QMChatMoreModePicture:
            [self.chatInputView showMoreView:NO];
            [self pictureBtnAction];
            break;
        case QMChatMoreModeCamera:
            [self.chatInputView showMoreView:NO];
            [self photoBtnAction];
            break;
        case QMChatMoreModeFile:
            [self.chatInputView showMoreView:NO];
            [self takeFileBtnAction];
            break;
        case QMChatMoreModeQuestion:
            break;
        case QMChatMoreModeEvaluate:
            self.chatInputView.inputView.inputView = nil;
            [self.chatInputView.inputView endEditing:YES];
            [self satisfactionAction:@"" sessionId:@""];
            break;
        case QMChatMoreModeCard:
            [self sendCard];
            break;
        default:
            break;
    }
}


// 获取文件
- (void)takeFileBtnAction {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    QMFileManagerController * fileViewController = [[QMFileManagerController alloc] init];
                    [self.navigationController pushViewController:fileViewController animated:true];
                }
                    break;
                case PHAuthorizationStatusDenied: {
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"title.prompt", nil) message: NSLocalizedString(@"title.photoAuthority", nil) preferredStyle: UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.set", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (UIApplicationOpenSettingsURLString != NULL) {
                            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                            [[UIApplication sharedApplication] openURL:appSettings];
                        }
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:action];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                    break;
                case PHAuthorizationStatusRestricted:
                    NSLog(@"相册访问受限!");
                    break;
                default:
                    break;
            }
        });
    }];
}

//通过摄像头获取图片
- (void)photoBtnAction {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

//相机代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImage * myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self sendImage:myImage];
        }];
        UIImageWriteToSavedPhotosAlbum(myImage, nil, nil, nil);
    }
}
- (void)pictureBtnAction {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            [self sendImage:image];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



@end
