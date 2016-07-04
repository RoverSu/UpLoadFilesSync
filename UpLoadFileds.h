//
//  UpLoadFileds.h
//  上传多个文件
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpLoadFileds : NSObject
+(NSData *)makeBody:(NSString *)filedName filedPath:(NSArray *)filedPath params:(NSDictionary *)params;

//上传单个文件
+(void)uploadFiled:(NSString *)urlString filedName:(NSString *)filedName filePath:(NSString *)filePath;

+(void)uploadFiled:(NSString *)urlString filedName:(NSString *)filedName filePath:(NSString *)filePath params:(NSDictionary *)params;

//上传多个文件
+(void)uploadFileds:(NSString *)urlString filedName:(NSString *)filedName filePaths:(NSArray *)filePaths params:(NSDictionary *)params;



@end
