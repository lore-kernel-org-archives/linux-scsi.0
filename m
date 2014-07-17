From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] bnx2i: Update driver version to 2.7.10.1
Date: Thu, 17 Jul 2014 05:19:49 -0400
Message-ID: <1405588789-31166-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:53447 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396AbaGQJwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2014 05:52:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 748ff8e..c8b410c 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -20,8 +20,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.7.6.2"
-#define DRV_MODULE_RELDATE	"Jun 06, 2013"
+#define DRV_MODULE_VERSION	"2.7.10.1"
+#define DRV_MODULE_RELDATE	"Jul 16, 2014"
 
 static char version[] =
 		"QLogic NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
-- 
1.8.2.GIT

