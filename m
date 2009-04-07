From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/15] qla2xxx: Correct hard-coded address of a second-port's NVRAM.
Date: Mon,  6 Apr 2009 22:33:44 -0700
Message-ID: <1239082431-19496-9-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZDGFd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:33:59 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 96ccb96..f389f3d 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1711,7 +1711,7 @@ struct ex_init_cb_81xx {
 #define FA_VPD0_ADDR_81		0xD0000
 #define FA_VPD1_ADDR_81		0xD0400
 #define FA_NVRAM0_ADDR_81	0xD0080
-#define FA_NVRAM1_ADDR_81	0xD0480
+#define FA_NVRAM1_ADDR_81	0xD0180
 #define FA_FEATURE_ADDR_81	0xD4000
 #define FA_FLASH_DESCR_ADDR_81	0xD8000
 #define FA_FLASH_LAYOUT_ADDR_81	0xD8400
-- 
1.6.2.2.404.ge96f3

