From: vikas.chaudhary@qlogic.com
Subject: [PATCH 02/13] qla4xxx: Print correct IDC version
Date: Thu, 20 Sep 2012 07:35:02 -0400
Message-ID: <1348140913-11828-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:34101 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754088Ab2ITLxE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:04 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 20825d5..9b67aad 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2809,7 +2809,7 @@ static int qla4_83xx_set_idc_ver(struct scsi_qla_host *ha)
 		qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DRV_IDC_VERSION, idc_ver);
 		ql4_printk(KERN_INFO, ha,
 			   "%s: IDC version updated to %d\n", __func__,
-			   QLA83XX_IDC_VER_MAJ_VALUE);
+			   idc_ver);
 	} else {
 		idc_ver = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_IDC_VERSION);
 		idc_ver &= 0xFF;
-- 
1.7.1

