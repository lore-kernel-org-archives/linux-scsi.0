From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI aic7xxx_old.c: make a function static (fwd)
Date: Wed, 24 Nov 2004 19:46:52 +0100
Message-ID: <20041124184652.GG19873@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:29444 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262888AbUKYAq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2004 19:46:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


The patch forwarded below still applies and compiles against 
2.6.10-rc2-mm3.

Please apply.


----- Forwarded message from Adrian Bunk <bunk@stusta.de> -----

Date:	Mon, 15 Nov 2004 02:53:00 +0100
From: Adrian Bunk <bunk@stusta.de>
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] SCSI aic7xxx_old.c: make a function static

The patch below makes the needlessly global function aic7xxx_info 
static.

diffstat output:
 drivers/scsi/aic7xxx_old.c              |    2 +-
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/aic7xxx_old.c.old	2004-11-13 17:15:23.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/aic7xxx_old.c	2004-11-13 17:16:12.000000000 +0100
@@ -1838,7 +1838,7 @@
  * Description:
  *   Return a string describing the driver.
  *-F*************************************************************************/
-const char *
+static const char *
 aic7xxx_info(struct Scsi_Host *dooh)
 {
   static char buffer[256];
--- linux-2.6.10-rc1-mm5-full/drivers/scsi/aic7xxx_old/aic7xxx_proc.c.old	2004-11-13 17:16:28.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/aic7xxx_old/aic7xxx_proc.c	2004-11-13 17:16:45.000000000 +0100
@@ -64,7 +64,7 @@
  * Description:
  *   Set parameters for the driver from the /proc filesystem.
  *-F*************************************************************************/
-int
+static int
 aic7xxx_set_info(char *buffer, int length, struct Scsi_Host *HBAptr)
 {
   proc_debug("aic7xxx_set_info(): %s\n", buffer);

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

