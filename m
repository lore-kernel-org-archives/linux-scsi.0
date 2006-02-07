From: "Marcus Franke" <MFranke@evendi.de>
Subject: SCSI errors again
Date: Tue, 7 Feb 2006 14:13:51 +0100
Message-ID: <AE41C3C123D61B45B457F3037275842F230622@DC-EX-001.evendi.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.kliff.de ([80.239.136.89]:10390 "EHLO smtp.kliff.de")
	by vger.kernel.org with ESMTP id S965067AbWBGNN5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 08:13:57 -0500
Received: from DC-EX-001.evendi.local ([85.183.128.34])
	by smtp.kliff.de (8.11.6/8.11.6) with ESMTP id k17DDpd09642
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 14:13:53 +0100
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

my Dell 2850 scsi raid controller/disks caused trouble again.

logwatch states these lines:

WARNING:  Kernel Errors Present
    I/O error: dev 08:03, sect...:  42Time(s)
    I/O error: dev 08:10, sect...:  1Time(s)
   SCSI disk error : host 0 channel...:  43Time(s)
   hda: drive_cmd: error=0x04Aborted Comm...:  1Time(s)
   hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }...:
1Time(s)

using again at the dellmgr application, I cannot see any errors
for the 4 disks! how can this be?

Full errors were:

Feb  6 19:31:21 master kernel:  I/O error: dev 08:03, sector 49435176
Feb  6 19:31:21 master kernel:  I/O error: dev 08:10, sector 70073264
Feb  6 19:31:21 master kernel:  I/O error: dev 08:03, sector 49435184
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 55196720
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 49435184
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 49435696
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 49435432
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 49435824
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 49435952
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 49435560
Feb  6 19:31:50 master kernel:  I/O error: dev 08:03, sector 49435312
Feb  6 19:51:38 master kernel:  I/O error: dev 08:03, sector 49435176
Feb  6 19:51:38 master kernel:  I/O error: dev 08:03, sector 49435184
Feb  6 19:52:06 master kernel:  I/O error: dev 08:03, sector 55197072
Feb  6 19:52:06 master kernel:  I/O error: dev 08:03, sector 49435184
Feb  6 19:52:06 master kernel:  I/O error: dev 08:03, sector 13130096
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 116495320
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434504
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434512
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 116495328
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434552
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434544
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434800
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435160
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434928
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435056
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435312
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435168
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49436496
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435552
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434656
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435176
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435560
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49436408
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434664
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49436320
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435184
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49435568
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49434672
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49436336
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49436760
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49436888
Feb  6 20:25:27 master kernel:  I/O error: dev 08:03, sector 49437096


Feb  6 20:25:27 master kernel: SCSI disk error : host 0 channel 0 id 0
lun 0 return code = 40001

Feb  6 20:06:01 master kernel: hda: drive_cmd: status=0x51 { DriveReady
SeekComplete Error }
Feb  6 20:06:01 master kernel: hda: drive_cmd: error=0x04Aborted Command


I guess one of my disks is going to be broken soon, but I am not able
to see which one.

System is RHEL3 using this Kernel from RHN:
2.4.21-37.ELsmp #1 SMP Wed Sep 7 13:28:55 EDT 2005 i686 i686 i386
GNU/Linux


Can someone please explain these error codes to me?

thanks,
Marcus
