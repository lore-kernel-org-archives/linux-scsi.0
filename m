From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 05/14] qla2xxx: Add support to load firmware from file for ISP 26XX/27XX.
Date: Thu, 9 Apr 2015 14:59:59 -0400
Message-ID: <1428606008-14976-6-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:12955 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933177AbbDITl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:29 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/Kconfig  |    3 +++
 drivers/scsi/qla2xxx/qla_os.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 113e6c9..33f60c9 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -18,6 +18,9 @@ config SCSI_QLA_FC
 	2322, 6322        ql2322_fw.bin
 	24xx, 54xx        ql2400_fw.bin
 	25xx              ql2500_fw.bin
+	2031              ql2600_fw.bin
+	8031              ql8300_fw.bin
+	27xx              ql2700_fw.bin
 
 	Upon request, the driver caches the firmware image until
 	the driver is unloaded.
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cce1cbc..e4851f8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5834,3 +5834,6 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
 MODULE_FIRMWARE(FW_FILE_ISP2322);
 MODULE_FIRMWARE(FW_FILE_ISP24XX);
 MODULE_FIRMWARE(FW_FILE_ISP25XX);
+MODULE_FIRMWARE(FW_FILE_ISP2031);
+MODULE_FIRMWARE(FW_FILE_ISP8031);
+MODULE_FIRMWARE(FW_FILE_ISP27XX);
-- 
1.7.7

