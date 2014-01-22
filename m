From: =?utf-8?q?Milan_Svoboda?= <milan.svoboda@centrum.cz>
Subject: =?utf-8?q?Re=3A_=5Busb=2Dstorage=5D_Re=3A_usb_disk_recognized_but_fails?=
Date: Wed, 22 Jan 2014 22:07:17 +0100
Message-ID: <20140122220717.D61BDE5D@centrum.cz>
References: <Pine.LNX.4.44L0.1401221446370.1310-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gmmr4.centrum.cz ([46.255.227.253]:59913 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbaAVVHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jan 2014 16:07:19 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401221446370.1310-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?q?Alan_Stern?= <stern@rowland.harvard.edu>
Cc: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, =?utf-8?q?USB_Storage_List?= <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

>
>> ffff8801fdbb2c00 2290129737 S Bo:3:004:2 -115 31 = 55534243 5f000000 00100000 80000a28 004a856e af000008 00000000 000000
>> ffff8801fdbb2c00 2290129782 C Bo:3:004:2 0 31 >
>> ffff8800d4a51b40 2290129803 S Bi:3:004:1 -115 4096 <
>> ffff8800d4a51b40 2301288990 C Bi:3:004:1 -32 512 = 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>> ffff8801fdbb2c00 2301289039 S Co:3:004:0 s 02 01 0000 0081 0000 0
>> ffff8801fdbb2c00 2301289068 C Co:3:004:0 0 0
>> ffff8801fdbb2c00 2301289086 S Bi:3:004:1 -115 13 <
>> ffff8801fdbb2c00 2301289153 C Bi:3:004:1 0 13 = 55534253 5f000000 00000000 01
>> ffff8801fdbb2c00 2301289189 S Bo:3:004:2 -115 31 = 55534243 60000000 12000000 80000603 00000012 00000000 00000000 000000
>> ffff8801fdbb2c00 2301289223 C Bo:3:004:2 0 31 >
>> ffff8800d188c780 2301289263 S Bi:3:004:1 -115 18 <
>> ffff8800d188c780 2301299693 C Bi:3:004:1 0 18 = 70000000 0000000a 00000000 00000000 0000
>> ffff8801fdbb2c00 2301299741 S Bi:3:004:1 -115 13 <
>> ffff8801fdbb2c00 2301299765 C Bi:3:004:1 0 13 = 55534253 60000000 00000000 00
>
>This continued a few more times until the computer gave up.  Maybe
>there is something wrong with one particular block at that address on
>the disk.

I tried to run fdisk /dev/sdb which obivously failed but it tried to access sectors 0, 1, 2, 3 which resulted in kernel log
messages reporting invalid sectors.
I tried to connect the disk with Windows and it was connected immediatelly, the partition is visible, I can read files, create files...
No signs of problems visible...

I don't know if it tells anything, but Windows reports the disk as USB 2.0 SATA bridge even when connected to USB-3 ports.

>
>Do you have a USB-2 port on the computer you can plug the disk into,
>instead of USB-3?
>

I tried it, but it is only one and separated on the other side of laptop so I could connect only one connector and the
result is the same.

Milan Svoboda

>Alan Stern
>
>
