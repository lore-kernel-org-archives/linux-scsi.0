From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/7] [Target_Core_Mod/IBLOCK]: Convert to use Linux/SCSI
	SCSI_3 define
Date: Mon, 26 Jan 2009 01:09:21 -0800
Message-ID: <1232960961.24642.130.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:24433 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752127AbZAZJJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 04:09:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 4bbf3522fc51145b666a7f6026361473baa413e4 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:39:54 -0800
Subject: [PATCH 5/7] [Target_Core_Mod/IBLOCK]: Convert to use Linux/SCSI SCSI_3 define

Make iblock_get_device_rev() return include/scsi/scsi.h:SCSI_3 (for
Target_Core_Mod/ConfigFS testing) and iblock_get_device_type() return
SCSI device type: TYPE_DISK following Linux/SCSI includes.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_iblock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 25e2318..29dc87b 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -837,12 +837,12 @@ extern u32 iblock_get_blocksize (se_device_t *dev)
 
 extern u32 iblock_get_device_rev (se_device_t *dev)
 {
-	return(02);
+	return(SCSI_3);
 }
 
 extern u32 iblock_get_device_type (se_device_t *dev)
 {
-	return(0); /* TYPE_DISK */
+	return(TYPE_DISK);
 }
 
 extern u32 iblock_get_dma_length (u32 task_size, se_device_t *dev)
-- 
1.5.4.1



