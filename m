From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sd.c remove unused include vmalloc.h
Date: Sun, 16 May 2004 12:24:47 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40A6D0EF.9050909@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070102050902090606040201"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:2060 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264868AbUEPCZO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2004 22:25:14 -0400
Received: from torque.net (d-237-180.stlucia.uq.net.au [203.101.237.180])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id i4G2PBL6000771
	for <linux-scsi@vger.kernel.org>; Sun, 16 May 2004 12:25:12 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070102050902090606040201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

   - remove unused include of vmalloc.h header in sd.c

Patch is against lk 2.6.6-bk1

Doug Gilbert

--------------070102050902090606040201
Content-Type: text/plain;
 name="sd.c266b1vm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd.c266b1vm"

--- linux/drivers/scsi/sd.c	2004-05-12 13:14:40.000000000 +1000
+++ linux/drivers/scsi/sd.c266b1vm	2004-05-16 11:26:27.000000000 +1000
@@ -45,7 +45,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/reboot.h>
-#include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/kref.h>

--------------070102050902090606040201--

