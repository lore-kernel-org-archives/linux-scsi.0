From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/21] qla2xxx: Update firmware filenames for new ISP parts.
Date: Thu,  3 Apr 2008 13:13:12 -0700
Message-ID: <1207253612-15538-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6395 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbYDCUNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:34 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 8c865b9..6208d56 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -16,7 +16,8 @@ config SCSI_QLA_FC
 	22xx              ql2200_fw.bin
 	2300, 2312, 6312  ql2300_fw.bin
 	2322, 6322        ql2322_fw.bin
-	24xx              ql2400_fw.bin
+	24xx, 54xx        ql2400_fw.bin
+	25xx              ql2500_fw.bin
 
 	Upon request, the driver caches the firmware image until
 	the driver is unloaded.
-- 
1.5.5.rc2

