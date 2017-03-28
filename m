From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/6] scsi: ufs: add missing macros for register bits from UFSHCI spec
Date: Tue, 28 Mar 2017 16:49:27 +0300
Message-ID: <20170328134929.25599-4-tkusumi@tuxera.com>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36502 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdC1NuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 09:50:16 -0400
Received: by mail-lf0-f65.google.com with SMTP id n78so10570877lfi.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2017 06:49:50 -0700 (PDT)
In-Reply-To: <20170328134929.25599-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add macros for register bits that can be found in JESD223C (v2.1).

Not all registers are defined in ufshci.h (i.e. some are unused
whether macros are defined or undefined), but all the bits for
those registers that are already defined should appear here.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshci.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index d14e9b9..88acfd3 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -48,6 +48,7 @@ enum {
 	REG_UFS_VERSION				= 0x08,
 	REG_CONTROLLER_DEV_ID			= 0x10,
 	REG_CONTROLLER_PROD_ID			= 0x14,
+	REG_AUTO_HIBERNATE_IDLE_TIMER		= 0x18,
 	REG_INTERRUPT_STATUS			= 0x20,
 	REG_INTERRUPT_ENABLE			= 0x24,
 	REG_CONTROLLER_STATUS			= 0x30,
@@ -171,6 +172,7 @@ enum {
 /* HCE - Host Controller Enable 34h */
 #define CONTROLLER_ENABLE	UFS_BIT(0)
 #define CONTROLLER_DISABLE	0x0
+#define CRYPTO_GENERAL_ENABLE	UFS_BIT(1)
 
 /* UECPA - Host UIC Error Code PHY Adapter Layer 38h */
 #define UIC_PHY_ADAPTER_LAYER_ERROR			UFS_BIT(31)
-- 
2.9.3
