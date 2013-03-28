From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 2/5] qla2xxx: Remove duplicated include form qla_isr.c
Date: Thu, 28 Mar 2013 08:21:24 -0400
Message-ID: <1364473287-27640-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:7238 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755265Ab3C1MoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 08:44:20 -0400
In-Reply-To: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 3f289c2..12e340e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -13,8 +13,6 @@
 #include <scsi/scsi_bsg_fc.h>
 #include <scsi/scsi_eh.h>
 
-#include "qla_target.h"
-
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
 static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
-- 
1.7.7

