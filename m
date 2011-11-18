From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 08/18] qla2xxx: Correct report-id acquisition check
Date: Fri, 18 Nov 2011 09:03:12 -0800
Message-ID: <1321635802-16491-9-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:45270
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758235Ab1KRRQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:28 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a168b7d..3745545 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2877,7 +2877,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		if (vp_idx == 0 && (MSB(stat) != 1))
 			goto reg_needed;
 
-		if (MSB(stat) == 1) {
+		if (MSB(stat) != 0) {
 			ql_dbg(ql_dbg_mbx, vha, 0x10ba,
 			    "Could not acquire ID for VP[%d].\n", vp_idx);
 			return;
-- 
1.6.0.2


