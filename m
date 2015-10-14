From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  1/2] qla2xxx: Remove unavailable firmware files
Date: Wed, 14 Oct 2015 11:57:40 -0400
Message-ID: <1444838261-20990-2-git-send-email-himanshu.madhani@qlogic.com>
References: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:5399 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbbJNQgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 12:36:33 -0400
In-Reply-To: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@lst.de
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Remove firmware binary names for the ISPs, which
are not submitted to linux-firmware

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c2dd17b..41aca16 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5293,11 +5293,6 @@ qla2x00_timer(scsi_qla_host_t *vha)
 #define FW_ISP2322	3
 #define FW_ISP24XX	4
 #define FW_ISP25XX	5
-#define FW_ISP81XX	6
-#define FW_ISP82XX	7
-#define FW_ISP2031	8
-#define FW_ISP8031	9
-#define FW_ISP27XX	10
 
 #define FW_FILE_ISP21XX	"ql2100_fw.bin"
 #define FW_FILE_ISP22XX	"ql2200_fw.bin"
@@ -5305,12 +5300,6 @@ qla2x00_timer(scsi_qla_host_t *vha)
 #define FW_FILE_ISP2322	"ql2322_fw.bin"
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
-#define FW_FILE_ISP81XX	"ql8100_fw.bin"
-#define FW_FILE_ISP82XX	"ql8200_fw.bin"
-#define FW_FILE_ISP2031	"ql2600_fw.bin"
-#define FW_FILE_ISP8031	"ql8300_fw.bin"
-#define FW_FILE_ISP27XX	"ql2700_fw.bin"
-
 
 static DEFINE_MUTEX(qla_fw_lock);
 
@@ -5321,11 +5310,6 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
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
@@ -5346,16 +5330,6 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		blob = &qla_fw_blobs[FW_ISP24XX];
 	} else if (IS_QLA25XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP25XX];
-	} else if (IS_QLA81XX(ha)) {
-		blob = &qla_fw_blobs[FW_ISP81XX];
-	} else if (IS_QLA82XX(ha)) {
-		blob = &qla_fw_blobs[FW_ISP82XX];
-	} else if (IS_QLA2031(ha)) {
-		blob = &qla_fw_blobs[FW_ISP2031];
-	} else if (IS_QLA8031(ha)) {
-		blob = &qla_fw_blobs[FW_ISP8031];
-	} else if (IS_QLA27XX(ha)) {
-		blob = &qla_fw_blobs[FW_ISP27XX];
 	} else {
 		return NULL;
 	}
@@ -5844,6 +5818,3 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
 MODULE_FIRMWARE(FW_FILE_ISP2322);
 MODULE_FIRMWARE(FW_FILE_ISP24XX);
 MODULE_FIRMWARE(FW_FILE_ISP25XX);
-MODULE_FIRMWARE(FW_FILE_ISP2031);
-MODULE_FIRMWARE(FW_FILE_ISP8031);
-MODULE_FIRMWARE(FW_FILE_ISP27XX);
-- 
1.7.7

