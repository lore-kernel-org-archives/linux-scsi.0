From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2] qla2xxx: Remove unavailable firmware files
Date: Tue, 17 Nov 2015 15:44:48 -0500
Message-ID: <1447793088-1619-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:8798 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932293AbbKQVYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 16:24:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Remove firmware binary names for the ISPs, which
are not submitted to linux-firmware

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/qla2xxx/Kconfig  |    3 ---
 drivers/scsi/qla2xxx/qla_os.c |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index a0f732b..10aa18b 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -18,9 +18,6 @@ config SCSI_QLA_FC
 	2322, 6322        ql2322_fw.bin
 	24xx, 54xx        ql2400_fw.bin
 	25xx              ql2500_fw.bin
-	2031              ql2600_fw.bin
-	8031              ql8300_fw.bin
-	27xx              ql2700_fw.bin
 
 	Upon request, the driver caches the firmware image until
 	the driver is unloaded.
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bfa9a64..6be32fd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5843,6 +5843,3 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
 MODULE_FIRMWARE(FW_FILE_ISP2322);
 MODULE_FIRMWARE(FW_FILE_ISP24XX);
 MODULE_FIRMWARE(FW_FILE_ISP25XX);
-MODULE_FIRMWARE(FW_FILE_ISP2031);
-MODULE_FIRMWARE(FW_FILE_ISP8031);
-MODULE_FIRMWARE(FW_FILE_ISP27XX);
-- 
1.7.7

