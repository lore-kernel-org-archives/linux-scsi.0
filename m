From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi/sysfs: delete extra kernel-doc
Date: Fri, 9 Jan 2009 15:28:13 -0800
Message-ID: <20090109152813.dab98271.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:45165 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZAIXbk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 18:31:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@hansenpartnership.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess SCSI sysfs kernel-doc:

Warning(linux-2.6.28-git13//drivers/scsi/scsi_sysfs.c:1049): Excess function parameter 'dev' description in 'scsi_sysfs_add_host'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_sysfs.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.28-git13.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.28-git13/drivers/scsi/scsi_sysfs.c
@@ -1043,7 +1043,6 @@ EXPORT_SYMBOL(scsi_register_interface);
 /**
  * scsi_sysfs_add_host - add scsi host to subsystem
  * @shost:     scsi host struct to add to subsystem
- * @dev:       parent struct device pointer
  **/
 int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
