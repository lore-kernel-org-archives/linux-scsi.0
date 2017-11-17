From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH try #2] scsi_devinfo: apply to HP-rebranded the same flags as Hitachi
Date: Fri, 17 Nov 2017 21:19:14 +0100
Message-ID: <20171117201914.8517-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:43346 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759039AbdKQUTT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 15:19:19 -0500
Received: by mail-wm0-f65.google.com with SMTP id x63so8696623wmf.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 12:19:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Takahiro Yasui <takahiro.yasui@hds.com>, Mike Christie <michaelc@cs.wisc.edu>, Matthias Rudolph <Matthias.Rudolph@hds.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>

627511e3e modified some Hitachi entries:

    Four models, OPEN-/DF400/DF500/DISK-SUBSYSTEM, can handle REPORT_LUN,
    and the BLIST_REPORTLUN2 flag needs to be set. And DF600 doesn't require
    any flags because it returns ANSI 03h (SPC).
~~~

The same should have been done also for HP counterparts.

Cc: Takahiro Yasui <takahiro.yasui@hds.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Matthias Rudolph <Matthias.Rudolph@hds.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 2464569..44d8cfb 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -186,9 +186,8 @@ static struct {
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
-	{"HP", "DF400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "DF500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "DF600", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "DF400", "*", BLIST_REPORTLUN2},
+	{"HP", "DF500", "*", BLIST_REPORTLUN2},
 	{"HP", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-- 
2.10.1
