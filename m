From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 5/6] SCSI: esas2r: smatch - Remove test for impossible condition (uint8 > 255)
Date: Thu, 29 Aug 2013 15:55:43 -0400
Message-ID: <1377806144-4902-6-git-send-email-bgrove@attotech.com>
References: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:54593 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755963Ab3H2Unz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 16:43:55 -0400
In-Reply-To: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, dan.carpenter@oracle.com, fengguang.wu@intel.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index f3d0cb8..e5b0902 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -415,7 +415,7 @@ static int csmi_ioctl_callback(struct esas2r_adapter *a,
 		lun = tm->lun;
 	}
 
-	if (path > 0 || tid > ESAS2R_MAX_ID) {
+	if (path > 0) {
 		rq->func_rsp.ioctl_rsp.csmi.csmi_status = cpu_to_le32(
 			CSMI_STS_INV_PARAM);
 		return false;
-- 
1.8.1.4

