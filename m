From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH for-next] qla2xxx: delete references to unused firmware files
Date: Sat, 16 May 2015 13:49:38 +0200
Message-ID: <1431776978-23510-1-git-send-email-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35823 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbbEPLuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 07:50:06 -0400
Received: by wgkx2 with SMTP id x2so20700111wgk.2
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 04:50:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, Linux Firmware Maintainers <linux-firmware@kernel.org>

There is no trace of these files in linux-firmware.git,
kernel sources, linux distributions or vendor site [1] :
ql8100_fw.bin ql8200_fw.bin ql2600_fw.bin ql8300_fw.bin ql2700_fw.bin

[1] http://ldriver.qlogic.com/firmware/

Cc: <qla2xxx-upstream@qlogic.com>
Cc: James E.J. Bottomley <JBottomley@odin.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: Linux Firmware Maintainers <linux-firmware@kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/qla2xxx/Kconfig  |  3 ---
 drivers/scsi/qla2xxx/qla_os.c | 13 -------------
 2 files changed, 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 33f60c9..113e6c9 100644
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
index 7462dd7..a9d0a82 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5296,11 +5296,6 @@ qla2x00_timer(scsi_qla_host_t *vha)
 #define FW_FILE_ISP2322	"ql2322_fw.bin"
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
-#define FW_FILE_ISP81XX	"ql8100_fw.bin"
-#define FW_FILE_ISP82XX	"ql8200_fw.bin"
-#define FW_FILE_ISP2031	"ql2600_fw.bin"
-#define FW_FILE_ISP8031	"ql8300_fw.bin"
-#define FW_FILE_ISP27XX	"ql2700_fw.bin"
 
 
 static DEFINE_MUTEX(qla_fw_lock);
@@ -5312,11 +5307,6 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
 	{ .name = FW_FILE_ISP24XX, },
 	{ .name = FW_FILE_ISP25XX, },
-	{ .name = FW_FILE_ISP81XX, },
-	{ .name = FW_FILE_ISP82XX, },
-	{ .name = FW_FILE_ISP2031, },
-	{ .name = FW_FILE_ISP8031, },
-	{ .name = FW_FILE_ISP27XX, },
 };
 
 struct fw_blob *
@@ -5834,6 +5824,3 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
 MODULE_FIRMWARE(FW_FILE_ISP2322);
 MODULE_FIRMWARE(FW_FILE_ISP24XX);
 MODULE_FIRMWARE(FW_FILE_ISP25XX);
-MODULE_FIRMWARE(FW_FILE_ISP2031);
-MODULE_FIRMWARE(FW_FILE_ISP8031);
-MODULE_FIRMWARE(FW_FILE_ISP27XX);
-- 
2.1.0

