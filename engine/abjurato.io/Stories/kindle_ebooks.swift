//
//  kindle_ebooks.swift
//  abjurato.io
//
//  Created by Anatoly Rosencrantz on 11/10/2020.
//  Copyright © 2020 Anatoly Rosencrantz. All rights reserved.
//

import Foundation
import Plot

extension Stories {
    static func kindle_ebooks(_ base: URL, _ parent: URL) -> HTMLConstructor {
        let storyname = "kindleEbooks"
        let filename = storyname + ".html"
        let address = parent.appendingPathComponent(filename)
        let image = base.appendingPathComponent("images").appendingPathComponent("4.jpeg")
        let generalCss = base.appendingPathComponent("general.css")
        let title = "Amazon Kindle: iOS App Reverse Engineering for eBooks Leaking"
        let date = "11/10/2020"
        
        return { HTML (
            .head(
                .stylesheet(generalCss.absoluteString),
                .title(title),
                .socialImageLink(image.absoluteString),
                .twitterCardType(.summary),
                .description(title),
                .url(address.absoluteString)
            ),
            .body (
                .a(.text("(lldb) thread step-out"), .href(base)), .class("comment"),
                
                .h1("\(title)"),
                .div(.i("Disclaimer: this was written back in February 2020.")),
                
                .br(),
                .p(
                    .text("I read a lot, and love non-fiction. But when it comets to ebooks, I prefer native Books.app of iOS - I got used to its controls, animations, and feeling of a \"one-stop shop\" for all the books I've read lately. So, every time I happen to buy a ebook, first thing I look for is - how can this book be imported into Books.app?")
                ),
                
                .p(.text("After "), .a(.href("https://abjurato.github.io/stories/alpinaEbooks.html"), .text("easy success")), .text(" with Alpina.Books app, I've decided to check out the state of the art - ebooks protection in "), .a(.href("https://apps.apple.com/us/app/amazon-kindle/id302584613"), .text("Amazon Kindle")), .text(" application for iOS.")),
                
                .h2("File System Artefacts"),
                
                .p(.text("Similarly, analyst starts with pulling app data from iOS device onto my mac. As one can remember from previous blogpost, apps have two readable/writable directories to store data produced during app runtime: directory of the app itself and AppGroups directories for sharing data between multiple apps (or app extensions) of one developer. Access to AppGroups is managed by system AppleMobileFileIntegrity.kext according to "), .i("entitlements"), .text(" that are baked into "), .i("code signature"), .text(". In order to know which AppGroups the app is allowed access to, we too can read entitlements of the bundle.")),
                
                .p(
                    .text("Fetching app bundle is not a big issue: run Filza file manager on a jailbroken device and find the bundle under "), .inline("/var/containers/Bundle/Application/"), .text(", and transfer it to the mac via SSH using "), .inline("scp"), .text(" command. A famous "), .inline("ldid"), .text(" tool helps us to dump entitlements of the bundle:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_01.png"))),
                    .text("Okay, here we see that app has access to AppGroup with identifier "), .i("group.com.amazon.Lassen"), .text(" and a similarly named shared Keychain. Unfortunately, in my case directory of this group was empty :)")
                ),
                
                .p(
                    .text("On the other hand, working directory of the app itself has a lot of stuff and even a folder called eBooks with a number of subfolders:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_02.png")))
                ),
                
                .p(
                    .text("There's also an SQL database at "), .inline("Library/Preferences/BookData.sqlite"), .text(" with a table named "), .inline("ZBOOK"), .text(", where each book has a familiar title in "), .inline("ZSORTTITLE"), .text(" and a local URL in "), .inline("ZPATH"), .text(":"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_03.png")))
                ),
                
                .p(
                    .text("Open one of these URLs and check the contents, and make sure "), .inline("ZMIMETYPE"), .text(" value "), .i("application/x-kfx-ebook"), .text(" did not lie - the book contents are stored in a proprietary Amazon format with a built-in DRM (witch at the time of writing is not publicly broken):"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_04.png"))),
                    .text("Okay, this looks like a dead end for me - I'm not a cryptography and DRM expert. Let's try to understand how the app itself decrypts these files maybe?")
                ),
                
                .h2("Static Analysis"),
                
                .p(.i("All executable binaries of AppStore apps are encrypted and signed - literally part of the Mach-O binary is encrypted and is decrypted only in memory during app launch by launchd system daemon. Hence the easiest way for us to obtain a decrypted binary (that we'll be able to disassemble to peek at its code) is to dump the decrypted part of it from device memory after launch and replace the encrypted chunk in the binary that we've already downloaded to the Mac. Additionally, if we'll want to run this binary later, we need to modify Mach-O launch commands (that sit in the beginning of the binary and explain to the system how this binary should be launched) to say that size of encrypted part is 0. This process is explained in more detail in one of my "), .a(.href("https://abjurato.github.io/topcards/decrypt_binary.html"), .text("cards")), .text(".")),
                
                .p(
                    .text("For this part we'll need a decrypted binary of the app. First of all, lets run a classic tool "), .inline("class-dump"), .text(" that will read appropriate section of the binary and re-create headers for Objective-C classes mentioned there:"),
                    .snippet("abjurato@Macintosh Desktop % ./class-dump -H -o <OURPUT_PATH> <PATH_TO_BINARY>"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_05.png")))
                ),
                
                .p(
                    .text("Okay, good news is that the app is written in Objective-C, but that's a lot of files. Which should we pay attention to? Let's open the binary in Hopper Disassembler and try to find some object or method with a hit in its name, like this one:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_06.png")))
                ),
                
                .p(
                    .text("Seemingly, object "), .inline("KfxBookBundle"), .text(" represents book at some level of abstraction, let's check it's headers dump: it has a property called "), .inline("allPieces"), .text(". If we'll run the app on device with a debugger connected, put a symbolic breakpoint at "), .inline("-[KfxBook initWithBundle:]"), .text(" and try to open one of the books, we'll see that this property contains an array of "), .inline("KfxBookPiece"), .text(" objects:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_07.png")))
                ),
                
                .p(
                    .text("Looking at the code of "), .inline("KfxBookBundle"), .text(" constructor, we can notice that it reads "), .b("BookManifest.kfx"), .text(" file as a CoreData database with a model named similarly - "), .b("KfxBookBundle"), .text(":"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_08.png"))),
                    .text("Let's try to change "), .b(".kfx"), .text(" extension to "), .b(".sqlite"), .text(" in one of the files we've obtained from from application working directory and open it. Looks like it's just a manifest tying together all files in a bundle:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_09.png"))),
                    .text("After hours of debugging and reading assembly, I've bumped into non-Objective-C and non-Swift code seemingly responsible for reading the contents of files and settings up environment to decrypt parts of the book file on-demand. Probably, this code is a library shared across all different Kindle readers - from iOS to Android to Amazon devices - and is linked statically into the iOS binary.")
                ),
                
                .h2("Dynamic Analysis"),
                
                .p(.text("Let's go opposite way - from UI down to business logic. In the end of the day, the text is somehow rendered on the screen! I'll omit the details of connecting debugger to the application - the manual process is complicated but Frida 'just works'.")),
                
                .p(
                    .text("After launching the app and opening a book, let's stop the process and ask lldb which UIViewController is currently presented:"),
                    .snippet("(lldb) po [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController]"),
                    .snippet(.i("<ReaderViewController: 0x1050ca600>"))
                ),
                
                .p(
                    .text("Looking at endless headers of this file, we notice "), .inline("ReaderModel"), .text(" reference, and "), .inline("ReaderModel"), .text(" object has a reference to "), .inline("BookMainData"), .text(" which inherits from "), .inline("NSManagedObject"), .text(", whose values we've seen in "), .inline("ZBOOK"), .text(" table of the main database:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_10.png")))
                ),
                
                .p(
                    .text("This binary is a “stripped” one, so we can not use names of methods and classes to set debugger breakpoints. We'll have to call Objective-C runtime "), .inline("objc_getClass"), .text(" and "), .inline("class_getMothodImplementation"), .text(" functions to define the addresses of methods of interest in the process memory instead. Setting a breakpoint in "), .inline("openBookWithBookId"), .text(" method of "), .inline("ReaderViewController"), .text(" looks like this:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_11.png")))
                ),
                
                .p(
                    .text("From the "), .inline("ReaderViewController"), .text(" header we can see that it has references to "), .inline("ReaderItem"), .text(" and "), .inline("KindleDocument"), .text(" objects:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_12.png"))),
                    .text("Where "), .inline("_barePronter"), .text(" looks interesting. Disassembler shows that a property with this names it used in "), .inline("-[BookTextExtractor textInfoForKindleDocument: forBookPositionRange]"), .text(" method:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_13.png"))),
                    .text("And if we'll add a breakpoint in the constructor of "), .inline("-[BookTextExtractorInfo initWithText:andWordCount:]"), .text(" and read the argument value, we'll see a chunk of text that presents on the screen:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_14.png")))
                ),
                
                .p(
                    .text("Can we trick the caller into passing there a longer chunk? After some time I've found a sibling method "), .inline("-[BookTextExtractor textInfoForBookPositionRange:usingIterator:]"), .text(" that is called in order to determine what is the language of the text on the screen and set up a build-in Google translator:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_15.png"))),
                    .text("This basically means that we only need to create a "), .inline("BookPositionRange"), .text(" object with valid start and end "), .inline("BookPosition"), .text(" values and pass to this method - and get all the text between these positions (later I'll notice that this text lacks any formatting).")
                ),
                
                .p(
                    .text("Digging deeper, we'll notice that "), .inline("ReaderViewController"), .text(" has a reference to "), .inline("KfxDocViewController"), .text(" with a reference to "), .inline("KfxPagePreviewModel"), .text(" which knows the positions of the beginnings of all chapters:"),
                    .screenshot(.src(base.appendingPathComponent("images").appendingPathComponent(storyname + "_16.png")))
                ),
                
                .p(
                    .text("Such way, a sequence of lldb commands to dump raw text of a chapter will look like this:"),
                    .gist(.src("https://gist.github.com/abjurato/b6a2fe170e31a4173b71f38d31ad8213.js")),
                    .text("Done!")
                ),
                
                .h2("Summary"),
                .p("Hooray? Probably. The process of breakpoints creation and chapters enumeration may be automated using lldb build-in Python scripting capability, but the lack of formatting is a problem to stay - sentences of dialogues are all merged together, and titles are stuck to the paragraphs, and paragraphs are not separated. I personally was not satisfied with this output and resorted to use the Kindle app for ebooks bought from Amazon."),
                
                .br(),
                .h2("Sources and Tools"),
                .p(.a(.href("https://www.objc.io/issues/17-security/inside-code-signing/"), .text("[0] Inside Code Signing"))),
                .p(.a(.href("https://www.theiphonewiki.com/wiki/AppleMobileFileIntegrity"), .text("[1] AppleMobileFileIntegrity"))),
                .p(.a(.href("https://iphonedevwiki.net/index.php/Ldid"), .text("[2] About ldid tool for codesigning"))),
                .p(.a(.href("https://derekselander.github.io/dsdump/"), .text("[3] Building a class-dump in 2020"))),
                .p(.a(.href("https://www.hopperapp.com"), .text("[4] Hopper Disassembler"))),
                .p(.a(.href("https://frida.re/docs/ios/"), .text("[5] Frida for dynamic analysis"))),
                .p(.a(.href("https://stackoverflow.com/a/42232823/4751521"), .text("[6] Setting a breakpoint in a stripped binary with LLDB"))),
                .p(.a(.href("https://lldb.llvm.org/use/python.html"), .text("[7] LLDB - Python Scripting"))),
                
                .br(),
                .div(.text(date), .class("comment"))
            )
        ) }
    }
}
