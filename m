From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] scsi: remove dead makefile about oktagon files
Date: Mon, 29 Jan 2018 12:30:16 +0000
Message-ID: <1517229016-1859-1-git-send-email-clabbe@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
List-Id: linux-scsi@vger.kernel.org

Remove line using inexistant files which were removed in
commit 642978beb483 ("[SCSI] remove m68k NCR53C9x based drivers")

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/scsi/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index fcfd28d2884c..de1b3fce936d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -185,7 +185,6 @@ ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-y) $(ncr53c8xx-flags-m)
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
-oktagon_esp_mod-objs	:= oktagon_esp.o oktagon_io.o
 
 # Files generated that shall be removed upon make clean
 clean-files :=	53c700_d.h 53c700_u.h
-- 
2.13.6
