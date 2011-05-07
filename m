From: madhu.iyengar@qlogic.com
Subject: [PATCH 09/12] qla2xxx: Clear complete initialization control block.
Date: Fri,  6 May 2011 17:30:20 -0700
Message-ID: <1304728223-30817-15-git-send-email-madhu.iyengar@qlogic.com>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32819 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753369Ab1EGAnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:11 -0400
In-Reply-To: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Use proper init_cb_size member which takes into account
MID/non-MID init-cb structure sizes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cb69693..920b76b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5210,7 +5210,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	}
 
 	/* Reset Initialization control block */
-	memset(icb, 0, sizeof(struct init_cb_81xx));
+	memset(icb, 0, ha->init_cb_size);
 
 	/* Copy 1st segment. */
 	dptr1 = (uint8_t *)icb;
-- 
1.6.0.2

