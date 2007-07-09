From: akpm@linux-foundation.org
Subject: [patch 16/17] CONFIG_SCSI_FD_8xx no longer exists
Date: Mon, 09 Jul 2007 12:00:11 -0700
Message-ID: <200707091900.l69J0Bin002559@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470AbXGITJc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:09:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, geert@linux-m68k.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

CONFIG_SCSI_FD_8xx no longer exists.

Apparently it was renamed to CONFIG_SCSI_SEAGATE, but the Makefile was
not correctly updated.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Makefile |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/scsi/Makefile~config_scsi_fd_8xx-no-longer-exists drivers/scsi/Makefile
--- a/drivers/scsi/Makefile~config_scsi_fd_8xx-no-longer-exists
+++ a/drivers/scsi/Makefile
@@ -90,7 +90,6 @@ obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_SEAGATE)	+= seagate.o
-obj-$(CONFIG_SCSI_FD_8xx)	+= seagate.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
 obj-$(CONFIG_SCSI_DTC3280)	+= dtc.o
_
