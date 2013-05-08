From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH RESEND] qla2xxx: Update firmware link in Kconfig file.
Date: Wed, 8 May 2013 10:39:35 -0400
Message-ID: <1368023975-5825-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:9052
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583Ab3EHPEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 11:04:07 -0400
Received: from mail4-co1 (localhost [127.0.0.1])	by mail4-co1-R.bigfish.com
 (Postfix) with ESMTP id E80EA1C0242	for <linux-scsi@vger.kernel.org>; Wed,  8
 May 2013 15:04:06 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Can you apply this for inclusion in 3.10-rc?

Thanks,
Chad

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


