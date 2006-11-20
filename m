From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/ipr.c: make 2 functions static
Date: Mon, 20 Nov 2006 03:23:46 +0100
Message-ID: <20061120022346.GF31879@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36113 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S933863AbWKTCXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 21:23:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/ipr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19-rc5-mm2/drivers/scsi/ipr.c.old	2006-11-20 00:50:09.000000000 +0100
+++ linux-2.6.19-rc5-mm2/drivers/scsi/ipr.c	2006-11-20 00:50:28.000000000 +0100
@@ -4615,7 +4615,7 @@
  * Return value:
  * 	0 on success / other on failure
  **/
-int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct ipr_resource_entry *res;
 
@@ -4655,7 +4655,7 @@
  * Return value:
  * 	EH_NOT_HANDLED
  **/
-enum scsi_eh_timer_return ipr_scsi_timed_out(struct scsi_cmnd *scsi_cmd)
+static enum scsi_eh_timer_return ipr_scsi_timed_out(struct scsi_cmnd *scsi_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_cmnd *ipr_cmd;

