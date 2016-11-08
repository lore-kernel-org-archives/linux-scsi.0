From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi_devinfo: remove synchronous ALUA for NETAPP/RDAC devices
Date: Tue,  8 Nov 2016 20:32:42 +0100
Message-ID: <20161108193242.3454-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34819 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753408AbcKHTdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 14:33:16 -0500
Received: by mail-wm0-f65.google.com with SMTP id a20so13929958wme.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2016 11:33:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin George <Martin.George@netapp.com>, Robert Stankey <Robert.Stankey@netapp.com>, Steven Schremmer <Steven.Schremmer@netapp.com>, Sean Stewart <Sean.Stewart@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

NetApp did confirm this is only required for ONTAP(LUN C-Mode).

Cc: Martin George <Martin.George@netapp.com>
Cc: Robert Stankey <Robert.Stankey@netapp.com>
Cc: Steven Schremmer <Steven.Schremmer@netapp.com>
Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 2464569..1fb7964 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -221,7 +221,6 @@ static struct {
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
 	{"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},
-	{"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},
 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
2.10.2

