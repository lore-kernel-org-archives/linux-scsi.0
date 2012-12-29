From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/3] qla4xxx: Pass correct function param to qla4_8xxx_rd_direct
Date: Sat, 29 Dec 2012 02:24:52 -0500
Message-ID: <1356765894-14001-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1356765894-14001-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:41840 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752060Ab2L2Hob (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2012 02:44:31 -0500
In-Reply-To: <1356765894-14001-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6096866..640d257 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5271,7 +5271,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		if (is_qla80XX(ha)) {
 			ha->isp_ops->idc_lock(ha);
 			dev_state = qla4_8xxx_rd_direct(ha,
-							QLA82XX_CRB_DEV_STATE);
+							QLA8XXX_CRB_DEV_STATE);
 			ha->isp_ops->idc_unlock(ha);
 			if (dev_state == QLA8XXX_DEV_FAILED) {
 				ql4_printk(KERN_WARNING, ha, "%s: don't retry "
-- 
1.7.8.GIT

