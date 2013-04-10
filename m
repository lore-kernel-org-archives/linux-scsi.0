From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] sun3_scsi: Fill in missing scsi_host_template.proc_info method
Date: Wed, 10 Apr 2013 13:52:08 +0200
Message-ID: <1365594729-25759-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/sun3_scsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 6e25889..b0dc034 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -626,6 +626,7 @@ static int sun3scsi_dma_finish(int write_flag)
 #include "sun3_NCR5380.c"
 
 static struct scsi_host_template driver_template = {
+	.proc_info		= sun3scsi_proc_info,
 	.name			= SUN3_SCSI_NAME,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
-- 
1.7.0.4
