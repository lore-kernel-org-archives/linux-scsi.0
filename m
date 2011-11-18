From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 07/18] qla2xxx: Fix to include FCE data as part of dump.
Date: Fri, 18 Nov 2011 09:03:11 -0800
Message-ID: <1321635802-16491-8-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:31250 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758231Ab1KRRQk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:40 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 58e0bfb..8607ab7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -369,7 +369,7 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 
 	memcpy(iter_reg, ha->fce, ntohl(fcec->size));
 
-	return iter_reg;
+	return (void *)iter_reg + ntohl(fcec->size);
 }
 
 static inline void *
-- 
1.6.0.2


