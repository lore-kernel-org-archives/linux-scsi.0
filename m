From: vikas.chaudhary@qlogic.com
Subject: [PATCH 01/11] qla4xxx: Remove unused code
Date: Mon, 13 Feb 2012 18:30:40 +0530
Message-ID: <1329138050-1042-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:5255
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756574Ab2BMNJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:54 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

This code initially added for FW debugging, we don't need this
code now so taking it out.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 78f1111..225e921 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1015,18 +1015,6 @@ qla4_8xxx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 	else
 		qla4_8xxx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xffffffff);
 
-	/* reset ms */
-	val = qla4_8xxx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
-	val |= (1 << 1);
-	qla4_8xxx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
-
-	msleep(20);
-	/* unreset ms */
-	val = qla4_8xxx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
-	val &= ~(1 << 1);
-	qla4_8xxx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
-	msleep(20);
-
 	qla4_8xxx_rom_unlock(ha);
 
 	/* Read the signature value from the flash.
-- 
1.7.8.247.g10f4e

