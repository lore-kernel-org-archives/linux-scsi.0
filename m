From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/4] qla4xxx: Return error if minidump data collection fails
Date: Fri, 23 Aug 2013 03:40:20 -0400
Message-ID: <1377243621-32107-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:45310 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132Ab3HWIJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 04:09:30 -0400
In-Reply-To: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Return error from function qla4_8xxx_collect_md_data()
if minidump data collection fails.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 53c759f..d001202 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2765,6 +2765,7 @@ skip_nxt_entry:
 		ql4_printk(KERN_INFO, ha,
 			   "Dump data mismatch: Data collected: [0x%x], total_data_size:[0x%x]\n",
 			   data_collected, ha->fw_dump_size);
+		rval = QLA_ERROR;
 		goto md_failed;
 	}
 
-- 
1.8.2.GIT

