From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 1/5] qla2xxx: Fix reset time out as qla2xxx not ack to reset request.
Date: Wed, 25 Apr 2012 07:26:13 -0700
Message-ID: <1335363977-6816-2-git-send-email-chad.dupuis@qlogic.com>
References: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:25593
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab2DYOlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 10:41:55 -0400
Received: from mail30-db3 (localhost [127.0.0.1])	by mail30-db3-R.bigfish.com
 (Postfix) with ESMTP id 7CA251E02F2	for <linux-scsi@vger.kernel.org>; Wed, 25
 Apr 2012 14:41:54 +0000 (UTC)
In-Reply-To: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index f052853..de722a9 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3125,6 +3125,7 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 		ql_log(ql_log_info, vha, 0x00b7,
 		    "HW State: COLD/RE-INIT.\n");
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_COLD);
+		qla82xx_set_rst_ready(ha);
 		if (ql2xmdenable) {
 			if (qla82xx_md_collect(vha))
 				ql_log(ql_log_warn, vha, 0xb02c,
-- 
1.6.0.2


