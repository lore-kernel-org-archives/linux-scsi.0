From: giridhar.malavali@qlogic.com
Subject: [PATCH 08/14] qla2xxx: Corrected one of the IOCB structure to be 64 bytes size
Date: Wed, 29 Jul 2009 11:03:57 -0700
Message-ID: <1248890643-761-9-git-send-email-giridhar.malavali@qlogic.com>
References: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35942 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751441AbZG2SEF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 14:04:05 -0400
In-Reply-To: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Shyam Sundar <shyam.sundar@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index dfde2dd..66a8da5 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1126,7 +1126,7 @@ struct vp_config_entry_24xx {
 	uint16_t id;
 	uint16_t reserved_4;
 	uint16_t hopct;
-	uint8_t reserved_5;
+	uint8_t reserved_5[2];
 };
 
 #define VP_RPT_ID_IOCB_TYPE	0x32	/* Report ID Acquisition entry. */
-- 
1.6.2.rc1.30.gd43c

