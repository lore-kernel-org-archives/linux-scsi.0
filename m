From: "Marcus Franke" <MFranke@evendi.de>
Subject: SCSI disk error // meaning of return code
Date: Fri, 27 Jan 2006 13:25:10 +0100
Message-ID: <AE41C3C123D61B45B457F3037275842F23030D@DC-EX-001.evendi.local>
Reply-To: <linux-scsi@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.kliff.de ([80.239.136.89]:1158 "EHLO smtp.kliff.de")
	by vger.kernel.org with ESMTP id S964816AbWA0MZN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 07:25:13 -0500
Received: from DC-EX-001.evendi.local ([85.183.128.34])
	by smtp.kliff.de (8.11.6/8.11.6) with ESMTP id k0RCP9711566
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2006 13:25:09 +0100
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everyone,

I found this error in my kernel log:

Jan 26 19:48:31 master kernel: SCSI disk error : host 0 channel 0 id 0
lun 0 return code = 40001
Jan 26 19:48:31 master kernel:  I/O error: dev 08:03, sector 68797224

Ok, so my first disk (id 0) at the first channel of my controller lost a
sector and hopefully replaced it with some spare sector.

But I did not find any information about the return code of 40001 on the
web or in the kernel code (drivers/scsi/**/*). Tried decimal, hex and
octal
versions of the code, but nothing.

Could someone please point me to some document where I can inform me 
about the meaning of this return code?

Second question is about this "dev 08:03" information in the second
string.
Will this point me to the particular disk, which "failed"? 

As the "disc" is a hardware raid of four discs exported to the operating
system as /dev/sda.

System is RHEL WS3 on a Dell PowerEdge 2850 using the 
Dell PowerEdge Expandable RAID controller 4 (rev 06).

When I have a look in the dellmgr application watching the discs I see
zero errors being logged there. No media errors or "other errors" and no
predictive failures.


Any hints or suggestions?


Marcus
