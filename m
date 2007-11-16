From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi kernel-doc: use correct function name
Date: Thu, 15 Nov 2007 17:07:28 -0800
Message-ID: <20071115170728.4bcb7687.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:28665 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbXKPBIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 20:08:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Use correct function name in kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_devinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- scsi-misc-26.orig/drivers/scsi/scsi_devinfo.c
+++ scsi-misc-26/drivers/scsi/scsi_devinfo.c
@@ -549,7 +549,7 @@ void scsi_exit_devinfo(void)
 }
 
 /**
- * scsi_dev_list_init - set up the dynamic device list.
+ * scsi_init_devinfo - set up the dynamic device list.
  *
  * Description:
  * 	Add command line entries from scsi_dev_flags, then add
