From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] osd_uld: fix printk format warning
Date: Thu, 23 Apr 2009 14:57:15 -0700
Message-ID: <49F0E43B.80501@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:43503 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZDWV4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 17:56:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in osd_uld:

drivers/scsi/osd/osd_uld.c:191: warning:format '%s' expects type 'char *', but argument 2 has type 'struct path'

Also fix a small typo.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/osd/osd_uld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090423.orig/drivers/scsi/osd/osd_uld.c
+++ linux-next-20090423/drivers/scsi/osd/osd_uld.c
@@ -188,7 +188,7 @@ struct osd_dev *osduld_path_lookup(const
 
 	error = kern_path(name, LOOKUP_FOLLOW, &path);
 	if (error) {
-		OSD_ERR("path_lookup of %s faild=>%d\n", path, error);
+		OSD_ERR("path_lookup of %s failed=>%d\n", name, error);
 		return ERR_PTR(error);
 	}
 

-- 
~Randy
