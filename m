From: Douglas Gilbert <dougg@torque.net>
Subject: aic7xxx build noise in 2.5.64
Date: Sun, 09 Mar 2003 17:04:52 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6AE794.5060909@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-241-128.stlucia.uq.net.au [203.101.241.128])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h2974mGf003217
	for <linux-scsi@vger.kernel.org>; Sun, 9 Mar 2003 17:04:49 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In 2.5.64 (+ .63 + .64bk3) at the end of a 'make bzImage'
I see:

....
make -rR -f scripts/Makefile.modpost
   scripts/modpost vmlinux drivers/scsi/advansys.o ...
... fs/vfat/vfat.o lib/zlib_deflate/zlib_deflate.o
*** Warning: Can't handle class_mask in
  	   drivers/scsi/aic7xxx/aic79xx:FFFF00
*** Warning: Can't handle class_mask in
            drivers/scsi/aic7xxx/aic7xxx:FFFF00
*** Warning: Can't handle class_mask in
            drivers/scsi/aic7xxx/aic7xxx:FFFF00

Doug Gilbert

