From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v15 5/9] ufs: added link status to ufshci
Date: Mon,  2 May 2016 14:55:31 +0100
Message-ID: <c51d85b78c3a9f6215eb468ea11d13a71abf4675.1462187952.git.jpinto@synopsys.com>
References: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:38268 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbcEBNzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 09:55:52 -0400
In-Reply-To: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
In-Reply-To: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
References: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, Joao Pinto <Joao.Pinto@synopsys.com>

Added link status to ufshci.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
Changes v12->v15:
- Nothing changed (just to keep up with patch set version).
Changes v0->v12 (Tomas Winkler):
- This patch only appeared in v12

 drivers/scsi/ufs/ufshci.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 3a2439f..6c7479c 100644
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

