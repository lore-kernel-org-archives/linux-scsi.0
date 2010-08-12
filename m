From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 5/5 v2] BNX2I: Updated version to bnx2i-2.1.3
Date: Thu, 12 Aug 2010 16:44:31 -0700
Message-ID: <1281656671-5369-6-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2889 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761159Ab0HLXmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 19:42:54 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Also updated maintainer info.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 1294936..50c2aa3 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -17,15 +17,17 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.1.2"
-#define DRV_MODULE_RELDATE	"Jun 28, 2010"
+#define DRV_MODULE_VERSION	"2.1.3"
+#define DRV_MODULE_RELDATE	"Aug 10, 2010"
 
 static char version[] __devinitdata =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
 		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
 
-MODULE_AUTHOR("Anil Veerabhadrappa <anilgv@broadcom.com>");
+MODULE_AUTHOR("Anil Veerabhadrappa <anilgv@broadcom.com> and "
+	      "Eddie Wai <eddie.wai@broadcom.com>");
+
 MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708/5709/57710/57711"
 		   " iSCSI Driver");
 MODULE_LICENSE("GPL");
-- 
1.7.0.5


