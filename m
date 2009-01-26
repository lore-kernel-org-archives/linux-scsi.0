From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/7] [Target_Core_Mod/RAMDISK]: Convert to use Linux/SCSI
	SCSI_2 define
Date: Mon, 26 Jan 2009 01:08:13 -0800
Message-ID: <1232960893.24642.126.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:21495 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753220AbZAZJIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 04:08:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From a47fe38c787c6052c3a3b1652212c9c748eb92ac Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:35:49 -0800
Subject: [PATCH 3/7] [Target_Core_Mod/RAMDISK]: Convert to use Linux/SCSI SCSI_2 define

Make rd_get_device_rev() return include/scsi/scsi.h:SCSI_2 and
rd_get_device_type() return SCSI device type: TYPE_DISK following
Linux/SCSI includes.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_rd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index e065d7d..e991bb6 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -1347,12 +1347,12 @@ extern u32 rd_get_blocksize (se_device_t *dev)
 
 extern u32 rd_get_device_rev (se_device_t *dev)
 {
-	return(02);
+	return(SCSI_2);
 }
 
 extern u32 rd_get_device_type (se_device_t *dev)
 {
-	return(0); /* TYPE_DISK */
+	return(TYPE_DISK);
 }
 
 /*	rd_get_dma_length(): (Part of se_subsystem_api_t template)
-- 
1.5.4.1



