From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 3/3] [BNX2I] update driver description and driver
 revision
Date: Thu, 25 Mar 2010 10:54:44 -0700
Message-ID: <1269539684.28522.68950.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4566 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab0CYRyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 13:54:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, mchan@broadcom.com, waie@broadcom.com

	[BNX2I] update driver description and driver revision

	* Add 10G devices to list of devices supported by bnx2i driver

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 737dce0..ce0ee80 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -17,8 +17,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.1.0"
-#define DRV_MODULE_RELDATE	"Dec 06, 2009"
+#define DRV_MODULE_VERSION	"2.1.1"
+#define DRV_MODULE_RELDATE	"Mar 24, 2010"
 
 static char version[] __devinitdata =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
@@ -26,7 +26,8 @@ static char version[] __devinitdata =
 
 
 MODULE_AUTHOR("Anil Veerabhadrappa <anilgv@broadcom.com>");
-MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708/5709 iSCSI Driver");
+MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708/5709/57710/57711"
+		   " iSCSI Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
-- 
1.6.5.1




