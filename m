From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] scsi ioctl: fix kernel-doc warning
Date: Wed, 22 Oct 2008 16:37:13 -0700
Message-ID: <48FFB929.4010507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:39850 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbYJVXh5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 19:37:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc parameter warning and correct the function name:

Warning(linux-next-20081022//drivers/scsi/scsi_ioctl.c:281): No description found for parameter 'ndelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20081022.orig/drivers/scsi/scsi_ioctl.c
+++ linux-next-20081022/drivers/scsi/scsi_ioctl.c
@@ -270,11 +270,11 @@ int scsi_ioctl(struct scsi_device *sdev,
 EXPORT_SYMBOL(scsi_ioctl);
 
 /**
- * scsi_nonblock_ioctl() - Handle SG_SCSI_RESET
+ * scsi_nonblockable_ioctl() - Handle SG_SCSI_RESET
  * @sdev: scsi device receiving ioctl
  * @cmd: Must be SC_SCSI_RESET
  * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,BUS,HOST}
- * @filp: either NULL or a &struct file which must have the O_NONBLOCK flag.
+ * @ndelay: file mode O_NDELAY flag
  */
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, int ndelay)
