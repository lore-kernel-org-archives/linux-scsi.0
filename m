From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 7/7 v2] BNX2I: Updated version from 2.1.1 to 2.1.2
Date: Thu, 1 Jul 2010 15:34:56 -0700
Message-ID: <1278023696-17817-8-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2236 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376Ab0GAWdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 18:33:54 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index f0f8361..a796f56 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -17,8 +17,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.1.1"
-#define DRV_MODULE_RELDATE	"Mar 24, 2010"
+#define DRV_MODULE_VERSION	"2.1.2"
+#define DRV_MODULE_RELDATE	"Jun 28, 2010"
 
 static char version[] __devinitdata =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
-- 
1.7.0.5


