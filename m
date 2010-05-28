From: giridhar.malavali@qlogic.com
Subject: [PATCH 15/17] qla2xxx: Removed redundant check for ISP 84xx.
Date: Fri, 28 May 2010 15:08:29 -0700
Message-ID: <1275084511-95266-16-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52689 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753592Ab0E1WIg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:36 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 085c246..b5adc12 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1208,7 +1208,7 @@ qla24xx_84xx_fw_version_show(struct device *dev,
 	if (!IS_QLA84XX(ha))
 		return snprintf(buf, PAGE_SIZE, "\n");
 
-	if (ha->cs84xx && ha->cs84xx->op_fw_version == 0)
+	if (ha->cs84xx->op_fw_version == 0)
 		rval = qla84xx_verify_chip(vha, status);
 
 	if ((rval == QLA_SUCCESS) && (status[0] == 0))
-- 
1.6.2.rc1.30.gd43c

