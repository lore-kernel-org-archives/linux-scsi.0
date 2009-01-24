From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/6] [Target_Core_Mod/RAMDISK]: Update
	transport_generic_emulate_inquiry() usage
Date: Fri, 23 Jan 2009 17:56:58 -0800
Message-ID: <1232762218.24642.16.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:27936 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754961AbZAXB5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 20:57:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 6d4128f111081e3dd0706a26ae2d8a44915b0d21 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 23 Jan 2009 17:22:04 -0800
Subject: [PATCH 2/6] [Target_Core_Mod/RAMDISK]: Update transport_generic_emulate_inquiry() usage

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_rd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index 9b6d859..e065d7d 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -430,7 +430,7 @@ static int rd_emulate_inquiry (se_task_t *task)
 
 	return(transport_generic_emulate_inquiry(cmd, TYPE_DISK, prod,
 			(hba->transport->do_se_mem_map) ? RD_DR_VERSION : RD_MCP_VERSION,
-			se_location, NULL));
+			se_location));
 }
 
 /*	rd_emulate_read_cap():
-- 
1.5.4.1



