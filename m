From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 21/24] qla4xxx: Update print statements in func qla4xxx_do_dpc()
Date: Mon, 16 Dec 2013 06:49:51 -0500
Message-ID: <1387194594-29817-22-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62178 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330Ab3LPMXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:39 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 410fe02..e8a8a7d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5283,9 +5283,9 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 		container_of(work, struct scsi_qla_host, dpc_work);
 	int status = QLA_ERROR;
 
-	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
-	    "flags = 0x%08lx, dpc_flags = 0x%08lx\n",
-	    ha->host_no, __func__, ha->flags, ha->dpc_flags))
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "scsi%ld: %s: DPC handler waking up. flags = 0x%08lx, dpc_flags = 0x%08lx\n",
+			  ha->host_no, __func__, ha->flags, ha->dpc_flags));
 
 	/* Initialization not yet finished. Don't do anything yet. */
 	if (!test_bit(AF_INIT_DONE, &ha->flags))
-- 
1.8.2.GIT

