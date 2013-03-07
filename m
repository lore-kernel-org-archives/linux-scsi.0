From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH RESEND] qla2xxx: Update firmware link in Kconfig file.
Date: Thu,  7 Mar 2013 10:30:22 -0500
Message-ID: <1362670222-8297-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:25644 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933035Ab3CGPw2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 10:52:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 317a7fd..23d6072 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -24,7 +24,9 @@ config SCSI_QLA_FC
 
 	Firmware images can be retrieved from:
 
-		ftp://ftp.qlogic.com/outgoing/linux/firmware/
+		http://ldriver.qlogic.com/firmware/
+
+	They are also included in the linux-firmware tree as well.
 
 config TCM_QLA2XXX
 	tristate "TCM_QLA2XXX fabric module for Qlogic 2xxx series target mode HBAs"
-- 
1.7.7

