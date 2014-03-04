//
//  AppDelegate.h
//  irctest
//
//  Created by clizby on 3/4/14.
//  Copyright (c) 2014 clizby. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
@private
    GCDAsyncSocket *asyncSocket;
    NSWindow *__unsafe_unretained window;
}

@property (assign) IBOutlet NSWindow *window;

@end
