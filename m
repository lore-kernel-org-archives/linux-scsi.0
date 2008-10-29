From: akpm@linux-foundation.org
Subject: [patch 17/17] scsi ioctl: fix kernel-doc warning
Date: Wed, 29 Oct 2008 14:24:48 -0700
Message-ID: <200810292124.m9TLOnVQ021320@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbYJ2VY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 17:24:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc parameter warning and correct the function name:

Warning(linux-next-20081022//drivers/scsi/scsi_ioctl.c:281): No description found for parameter 'ndelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_ioctl.c~scsi-ioctl-fix-kernel-doc-warning drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c~scsi-ioctl-fix-kernel-doc-warning
+++ a/drivers/scsi/scsi_ioctl.c
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
_
