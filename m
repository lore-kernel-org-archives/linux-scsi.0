From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 05/22] qla2xxx: Add BPM support for ISP25xx.
Date: Wed, 30 Oct 2013 03:38:12 -0400
Message-ID: <1383118709-5569-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:58656 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752771Ab3J3ILW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:22 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ccc30d4..5957fee 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -468,7 +468,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
-		if (IS_QLA81XX(ha) || IS_QLA83XX(ha)) {
+		if (IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA83XX(ha)) {
 			struct nvram_81xx *nv = ha->nvram;
 			mcp->mb[4] = (nv->enhanced_features &
 			    EXTENDED_BB_CREDITS);
-- 
1.7.7

