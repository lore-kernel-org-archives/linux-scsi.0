From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/8] qla2xxx: Add MODULE_FIRMWARE tags.
Date: Mon,  2 Oct 2006 12:00:48 -0700
Message-ID: <11598156512698-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964946AbWJBTA5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:57 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9e665e1..cdc7fca 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2564,14 +2564,20 @@ #define FW_ISP2300	2
 #define FW_ISP2322	3
 #define FW_ISP24XX	4
 
+#define FW_FILE_ISP21XX	"ql2100_fw.bin"
+#define FW_FILE_ISP22XX	"ql2200_fw.bin"
+#define FW_FILE_ISP2300	"ql2300_fw.bin"
+#define FW_FILE_ISP2322	"ql2322_fw.bin"
+#define FW_FILE_ISP24XX	"ql2400_fw.bin"
+
 static DECLARE_MUTEX(qla_fw_lock);
 
 static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
-	{ .name = "ql2100_fw.bin", .segs = { 0x1000, 0 }, },
-	{ .name = "ql2200_fw.bin", .segs = { 0x1000, 0 }, },
-	{ .name = "ql2300_fw.bin", .segs = { 0x800, 0 }, },
-	{ .name = "ql2322_fw.bin", .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
-	{ .name = "ql2400_fw.bin", },
+	{ .name = FW_FILE_ISP21XX, .segs = { 0x1000, 0 }, },
+	{ .name = FW_FILE_ISP22XX, .segs = { 0x1000, 0 }, },
+	{ .name = FW_FILE_ISP2300, .segs = { 0x800, 0 }, },
+	{ .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
+	{ .name = FW_FILE_ISP24XX, },
 };
 
 struct fw_blob *
@@ -2702,3 +2708,8 @@ MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic Fibre Channel HBA Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(QLA2XXX_VERSION);
+MODULE_FIRMWARE(FW_FILE_ISP21XX);
+MODULE_FIRMWARE(FW_FILE_ISP22XX);
+MODULE_FIRMWARE(FW_FILE_ISP2300);
+MODULE_FIRMWARE(FW_FILE_ISP2322);
+MODULE_FIRMWARE(FW_FILE_ISP24XX);
-- 
1.4.2.3.gf59615

