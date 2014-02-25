From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 07/10] qla4xxx: Check for correct return status
Date: Mon, 24 Feb 2014 22:07:02 -0500
Message-ID: <1393297625-928-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:31600 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaBYDnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:43:11 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Check for correct return status in function -
qla4_8xxx_minidump_pex_dma_read

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 8a56209..9dbdb4b 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2105,7 +2105,7 @@ static int qla4_8xxx_minidump_pex_dma_read(struct scsi_qla_host *ha,
 			      (uint64_t)m_hdr->desc_card_addr,
 			      (uint32_t *)&dma_desc,
 			      (sizeof(struct qla4_83xx_pex_dma_descriptor)/16));
-		if (rval == -1) {
+		if (rval != QLA_SUCCESS) {
 			ql4_printk(KERN_INFO, ha,
 				   "%s: Error writing rdmem-dma-init to MS !!!\n",
 				   __func__);
-- 
1.8.2.GIT

