#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <objc/runtime.h>
#import <stdlib.h>
#import <stdio.h>
#include<string.h>
#import <unistd.h>
#import <pthread.h>
#import <sys/stat.h>
#import <sys/types.h>
#include <spawn.h>
#include <signal.h>

int file_exist(char *filename) {
    struct stat buffer;
    int r = stat(filename, &buffer);
    return (r == 0);
}

void disableDaemons() {
	setuid(0);
	setgid(0);
	pid_t pid;
	int status;
	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	NSError *error = nil;
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	// system("/bin/sh /var/mobile/fix.sh");
}

// void disableDaemon() {
// 	NSError *error = nil;
// 	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
// 	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
// 	// rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
//     // rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
// 	// dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
// 	//     if (file_exist((char *)"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist")) {
// 	//         rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
// 	//     } else {

// 	//     }

// 	//     if (file_exist((char *)"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd")) {
	        
// 	//     } else {

// 	//     }
	    
// 	//     dispatch_async(dispatch_get_main_queue(), ^(void) {
// 	//         if (file_exist((char *)"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist")) {
// 	//             rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
// 	//         } else {

// 	//         }

// 	//         if (file_exist((char *)"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd")) {
// 	//             rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
// 	//         } else {

// 	//         }
// 	//     });
// 	// });
// }

@interface NSUserDefaults ()
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

__attribute__((constructor)) int main(int argc, char **argv, char **envp)
{
	setgid(501);
	setuid(501);
	
	[[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"MobileAssetSUAllowOSVersionChange" inDomain:@"com.apple.MobileAsset"];
	[[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"MobileAssetSUAllowSameVersionFullReplacement" inDomain:@"com.apple.MobileAsset"];
	[[NSUserDefaults standardUserDefaults] setObject:@"http://mesu.apple.com/assets/tvOSDeveloperSeed" forKey:@"MobileAssetServerURL-com.apple.MobileAsset.SoftwareUpdate" inDomain:@"com.apple.MobileAsset"];
	[[NSUserDefaults standardUserDefaults] setObject:@"http://mesu.apple.com/assets/tvOSDeveloperSeed" forKey:@"MobileAssetServerURL-com.apple.MobileAsset.MobileSoftwareUpdate.UpdateBrain" inDomain:@"com.apple.MobileAsset"];
	
	[[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"kBadgedForSoftwareUpdateKey" inDomain:@"com.apple.Preferences"];
	[[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"kBadgedForSoftwareUpdateJumpOnceKey" inDomain:@"com.apple.Preferences"];	
	
	return 0;
}

%hook PSUIGeneralController
	// - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// 	// Return the number of rows in the section.
	// 	// %orig;
	// 	if (section == 0) {
	// 		return 1;
	// 	}

	// 	return %orig;
	// }
	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		// Return the number of rows in the section.
		// %orig;
		if (section == 0) {
			return 2;
		}

		return %orig;
	}

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	    static NSString *CellIdentifier = @"reuseIdentifier";

	    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	    // indexPath.row - 1
	    // if (cell == nil) {
	    //     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	    // }

	    // cell.textLabel.text = contentsForThisRow;
	    // if ([indexPath row] > 0 ) {
	    //     cell.selectionStyle = UITableViewCellSelectionStyleNone;
	    //     cell.userInteractionEnabled = NO;
	    //     cell.textLabel.textColor = [UIColor lightGrayColor];
	    // }
	    // return cell;
	    // NSInteger count = [tableView numberOfRowsInSection:[indexPath section]] - 1;
	    switch(indexPath.section) {
	        case 0:
        		if(indexPath.row == 1) {
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
					//configure cell
					// cell.titleText.text = @"badiOSbad";
					cell.textLabel.text = @"Protected By";
					cell.detailTextLabel.text = @"badiOSbad";
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					return cell;
               	} else {
               		return %orig;
               	}
            	break;
	        default:
                break;
	    }
	    return %orig;
	}

	- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
		switch(indexPath.section) {
	        case 0:
        		if(indexPath.row == 1) {
        			
               	} else {
               		%orig;
               	}
            	break;
	        default:
                break;
	    }
	    %orig;
	}

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        switch(indexPath.section) {
	        case 0:
        		if(indexPath.row == 1) {
        			NSString *scheme = @"cydia://url/https://cydia.saurik.com/api/share#?source=https%3A%2F%2Fignition.fun%2Frepo%2F";
        			UIApplication *application = [UIApplication sharedApplication];
					NSURL *URL = [NSURL URLWithString:scheme];

					// if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
					//    [application openURL:URL options:@{}
					//    completionHandler:^(BOOL success) {
					//         NSLog(@"Open %@: %d",scheme,success);
					//     }];
					//  } else {
					//    BOOL success = [application openURL:URL];
					//    NSLog(@"Open %@: %d",scheme,success);
					//  }
					BOOL success = [application openURL:URL];
					NSLog(@"Open %@: %d",scheme,success);
               	} else {
               		%orig;
               	}
            	break;
	        default:
                break;
	    }
	    %orig;
	}
%end

// %hook PSUIPrefsListController
// 	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// 		// Return the number of rows in the section.
// 		// %orig;
// 		if (section == 0) {
// 			return %orig + 1;
// 		}

// 		return %orig;
// 	}

// 	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

// 	    static NSString *CellIdentifier = @"reuseIdentifier";

// 	    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
// 	    // indexPath.row - 1
// 	    // if (cell == nil) {
// 	    //     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
// 	    // }

// 	    // cell.textLabel.text = contentsForThisRow;
// 	    // if ([indexPath row] > 0 ) {
// 	    //     cell.selectionStyle = UITableViewCellSelectionStyleNone;
// 	    //     cell.userInteractionEnabled = NO;
// 	    //     cell.textLabel.textColor = [UIColor lightGrayColor];
// 	    // }
// 	    // return cell;
// 	    // NSInteger count = [tableView numberOfRowsInSection:[indexPath section]] - 1;
// 	    switch(indexPath.section) {
// 	        case 0:
//         		if(indexPath.row == 1) {
// 					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
// 					//configure cell
// 					// cell.titleText.text = @"badiOSbad";
// 					cell.textLabel.text = @"Protected By";
// 					cell.detailTextLabel.text = @"badiOSbad";
// 					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
// 					return cell;
//                	} else {
//                		return %orig;
//                	}
//             	break;
// 	        default:
//                 break;
// 	    }
// 	    return %orig;
// 	}

// 	- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
// 		switch(indexPath.section) {
// 	        case 0:
//         		if(indexPath.row == 1) {
        			
//                	} else {
//                		%orig;
//                	}
//             	break;
// 	        default:
//                 break;
// 	    }
// 	    %orig;
// 	}

// 	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//         switch(indexPath.section) {
// 	        case 0:
//         		if(indexPath.row == 1) {
//         			NSString *scheme = @"cydia://url/https://cydia.saurik.com/api/share#?source=https%3A%2F%2Fignition.fun%2Frepo%2F";
//         			UIApplication *application = [UIApplication sharedApplication];
// 					NSURL *URL = [NSURL URLWithString:scheme];

// 					// if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
// 					//    [application openURL:URL options:@{}
// 					//    completionHandler:^(BOOL success) {
// 					//         NSLog(@"Open %@: %d",scheme,success);
// 					//     }];
// 					//  } else {
// 					//    BOOL success = [application openURL:URL];
// 					//    NSLog(@"Open %@: %d",scheme,success);
// 					//  }
// 					BOOL success = [application openURL:URL];
// 					NSLog(@"Open %@: %d",scheme,success);
//                	} else {
//                		%orig;
//                	}
//             	break;
// 	        default:
//                 break;
// 	    }
// 	    %orig;
// 	}
// %end

%hook SBLockScreenViewController
	-(void)finishUIUnlockFromSource:(int)source {
	    %orig;
	    setuid(0);
	    	setgid(0);
	    	pid_t pid;
	    	int status;
	    	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	    	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	    	waitpid(pid, &status, WEXITED);
	    	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	    	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	    	NSError *error = nil;
	    	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	    	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}
%end

%hook SBDashBoardViewController
	-(void)finishUIUnlockFromSource:(int)source {
	    %orig;
	    setuid(0);
	    	setgid(0);
	    	pid_t pid;
	    	int status;
	    	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	    	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	    	waitpid(pid, &status, WEXITED);
	    	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	    	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	    	NSError *error = nil;
	    	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	    	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}
%end

%hook SpringBoard

	-(void)applicationDidFinishLaunching:(id)application {
		%orig;
		setuid(0);
			setgid(0);
			pid_t pid;
			int status;
			const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
			posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
			waitpid(pid, &status, WEXITED);
			rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
			rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
			NSError *error = nil;
			[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
			[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}

%end

%hook SBFLockScreenDateView

-(void)didMoveToSuperview {

    %orig;

	setuid(0);
	setgid(0);
	pid_t pid;
	int status;
	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	NSError *error = nil;
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];

}

%end

%hook SBHomeScreenViewController

-(void)viewWillAppear:(BOOL)animated {
	%orig;
	setuid(0);
	setgid(0);
	pid_t pid;
	int status;
	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	NSError *error = nil;
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];

	// NSString *title = @"badiOSbad is Active";
	// NSString *message = [NSString stringWithFormat:@"You are now protected from the nasty iOS!"];
	
	// UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	// [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];

	// [self presentViewController:alert animated:YES completion:nil];    
}

-(void)viewDidAppear:(BOOL)animated {

	%orig;

	setuid(0);
	setgid(0);
	pid_t pid;
	int status;
	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	NSError *error = nil;
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];


 //    NSString *title = @"badiOSbad is Active";
	// NSString *message = [NSString stringWithFormat:@"You are now protected from the nasty iOS!"];
	
	// UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	// [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];

	// [self presentViewController:alert animated:YES completion:nil];

}

%end

%hook SBCoverSheetSlidingViewControllerDelegate

-(void)coverSheetSlidingViewControllerUserPresentGestureBegan:(id)arg1 {
	%orig;

	setuid(0);
	setgid(0);
	pid_t pid;
	int status;
	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	NSError *error = nil;
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];

 //    NSString *title = @"badiOSbad is Active";
	// NSString *message = [NSString stringWithFormat:@"You are now protected from the nasty iOS!"];
	
	// UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	// [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];

	// [self presentViewController:alert animated:YES completion:nil];
}

%end

%hook SBCoverSheetPresentationDelegate

	-(void)setDismissingCoverSheet:(BOOL)arg1 {
		%orig;
		setuid(0);
		setgid(0);
		pid_t pid;
		int status;
		const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
		posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
		rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
		rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
		NSError *error = nil;
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
		// NSString *title = @"badiOSbad is Active";
		// NSString *message = [NSString stringWithFormat:@"You are now protected from the nasty iOS!"];
		
		// UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
		
		// [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];

		// [self presentViewController:alert animated:YES completion:nil];    
	}

%end

%hook SBIconController

-(void)_coverSheetDidPresent:(id)arg1 {
	%orig;
	setuid(0);
	setgid(0);
	pid_t pid;
	int status;
	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	NSError *error = nil;
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	// NSString *title = @"badiOSbad is Active";
	// NSString *message = [NSString stringWithFormat:@"You are now protected from the nasty iOS!"];
	
	// UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	// [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];

	// [self presentViewController:alert animated:YES completion:nil];    
}

-(void)_lockScreenUIWillLock:(id)arg1 {
	%orig;
	setuid(0);
	setgid(0);
	pid_t pid;
	int status;
	const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
	posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
	rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
	rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
	NSError *error = nil;
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
	[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	// NSString *title = @"badiOSbad is Active";
	// NSString *message = [NSString stringWithFormat:@"You are now protected from the nasty iOS!"];
	
	// UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	// [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];

	// [self presentViewController:alert animated:YES completion:nil];    
}

// 8

-(void)showDeveloperBuildExpirationAlertIfNecessary {}

// 9+10
- (void)showDeveloperBuildExpirationAlertIfNecessaryFromLockscreen:(_Bool)arg1 toLauncher:(_Bool)arg2 {}

%end

// 11
%hook SBDeveloperBuildExpirationTrigger

- (void)showDeveloperBuildExpirationAlertIfNecessaryFromLockscreen:(_Bool)arg1 toLauncher:(_Bool)arg2 {}

%end

// might help
%hook SBLockdownManager
- (id)developerBuildExpirationDate { return [NSDate distantFuture]; }
%end

%hook SBDeveloperBuildExpirationTrigger

	-(void)_setExpirationDate:(id)arg1 {
	    %orig([NSDate dateWithTimeIntervalSince1970: 25488338400]);
	}

	-(NSDate *)expirationDate {
	    return [NSDate dateWithTimeIntervalSince1970: 25488338400];
	}

%end

%hook MIInstallableBundle
	- (id)_validateBundle:(id)bundle
	    validatingResources:(BOOL)maybe1
	    performingOnlineAuthorization:(BOOL)maybe2
	    verifyingForMigrator:(BOOL)maybe3
	    allowingFreeProfileValidation:(BOOL)maybe4
	    error:(id *)error {
	    return %orig(bundle, maybe1, maybe2, maybe3, YES, error);
	}
%end

%hook DMFApplication

	BOOL _isValidated = YES;

	 - (BOOL)isValidated {
	 	return YES;
	 }

%end

%hook DMFProvisioningProfile

	- (NSDate *)expirationDate {
		// %orig;
		// NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		// [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
		// NSDate *date = [dateFormat dateFromString:dateStr];
		return [NSDate dateWithTimeIntervalSince1970: 25488338400];
		// return [NSDate dateWithTimeIntervalSince1970: 1531302817];
	}

%end

%hook SBHomeHardwareButton
	
	-(void)singlePressUp:(id)arg1 {
		%orig;
		setuid(0);
		setgid(0);
		pid_t pid;
		int status;
		const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
		posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
		rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
		rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
		NSError *error = nil;
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}

	-(void)_singlePressUp:(id)arg1 {
		%orig;
		setuid(0);
		setgid(0);
		pid_t pid;
		int status;
		const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
		posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
		rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
		rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
		NSError *error = nil;
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}

	-(void)doublePressUp:(id)arg1 {
		%orig;
		setuid(0);
		setgid(0);
		pid_t pid;
		int status;
		const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
		posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
		rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
		rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
		NSError *error = nil;
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}

	-(void)doubleTapUp:(id)arg1 {
		%orig;
		setuid(0);
		setgid(0);
		pid_t pid;
		int status;
		const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
		posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
		rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
		rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
		NSError *error = nil;
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}

	-(void)longPress:(id)arg1 {
		%orig;
		setuid(0);
		setgid(0);
		pid_t pid;
		int status;
		const char *argv[] = {"sh", "/var/mobile/fix.sh", NULL};
		posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, NULL);
		waitpid(pid, &status, WEXITED);
		rename("/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist", "/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk");
		rename("/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd", "/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk");
		NSError *error = nil;
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist" toPath:@"/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist.bk" error:&error];
		[[NSFileManager defaultManager] moveItemAtPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd" toPath:@"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd.bk" error:&error];
	}

%end

%hook SUSoftwareUpdateAssetMatcher

	- (BOOL)_isPossibleSoftwareUpdate:(id)arg1 {
		return NO;
	}

	-(BOOL)compareWithTatsuForEligibility {
		return NO;
	}

	-(BOOL)_isDeviceEligibleForUpdate:(id)arg1 {
		return NO;
	}

%end