From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v16 5/9] ufs: add link status to ufshci
Date: Wed, 11 May 2016 12:21:29 +0100
Message-ID: <3d09d2b69b5ee996a0c1396d73cde875db8853b6.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:36290 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcEKLVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2016 07:21:48 -0400
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

Add link status to ufshci.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
Changes v12->v16:
- Nothing changed (just to keep up with patch set version).
Changes v0->v12 (Tomas Winkler):
- This patch only appeared in v12

 drivers/scsi/ufs/ufshci.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 36f5879..9599741 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -220,6 +220,12 @@ enum {
 #define UIC_ARG_ATTR_TYPE(t)		(((t) & 0xFF) << 16)
 #define UIC_GET_ATTR_ID(v)		(((v) >> 16) & 0xFFFF)
 
+/* Link Status*/
+enum link_status {
+	UFSHCD_LINK_IS_DOWN	= 1,
+	UFSHCD_LINK_IS_UP	= 2,
+};
+
 /* UIC Commands */
 enum uic_cmd_dme {
 	UIC_CMD_DME_GET			= 0x01,
-- 
1.8.1.5

