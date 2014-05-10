From: loody <miloody@gmail.com>
Subject: Weird I/O errors with USB Hard disk
Date: Sat, 10 May 2014 22:38:17 +0800
Message-ID: <CANudz+s6iyZtLLVcJ-tcZVRP1gAJOQzU4Spq23=yRd8PcvfK_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56154 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbaEJOiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 May 2014 10:38:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>

hi all:
I have a USB hard disk and when I play specific file.
it will show below message
( I purpose enable usb/storage/transport.c debug message about urb debug)
what makes me confused are
1. Does " Unhandled sense code" mean the " SCSI Request Sense" command?
2. if #1 is correct, there should be any error handling for not keep
sending following commands. Why usb driver keep clear this halt
enpoint?
isn't there any timeout mechanism no matter in scsi layer or usb layer?

appreciate your help


[22:06:48]clearing endpoint halt for pipe 0xc0008280
[22:06:48]sd 0:0:0:0: [sda] Unhandled sense code
[22:06:48]sd 0:0:0:0: [sda]  Result: hostbyte=0x10 driverbyte=0x08
[22:06:48]sd 0:0:0:0: [sda]  Sense Key : 0x3 [current]
[22:06:48]sd 0:0:0:0: [sda]  ASC=0x11 ASCQ=0x0
[22:06:48]sd 0:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 24 42 22 00 00 f0 00
[22:06:48]end_request: critical target error, dev sda, sector 2376226
[22:06:48]-- short read transfer
[22:06:48]clearing endpoint halt for pipe 0xc0008280
[22:06:48]-- short read transfer
[22:06:48]clearing endpoint halt for pipe 0xc0008280
[22:06:48]-- short read transfer
[22:06:48]clearing endpoint halt for pipe 0xc0008280
[22:06:48]-- short read transfer
[22:06:48]clearing endpoint halt for pipe 0xc0008280
[22:06:48]-- short read transfer
[22:06:48]clearing endpoint halt for pipe 0xc0008280
[22:06:48]-- short read transfer
[22:06:48]clearing endpoint halt for pipe 0xc0008280
[22:06:48]-- short read transfer
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
[22:06:49]-- short read transfer
[22:06:49]clearing endpoint halt for pipe 0xc0008280
..................
