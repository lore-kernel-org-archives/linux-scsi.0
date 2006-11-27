From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] qla2xyz: use NULL instead of 0
Date: Mon, 27 Nov 2006 09:35:42 -0800
Message-ID: <20061127093542.1dd8c0a8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:52915 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1755972AbWK0Rfe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 12:35:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: linux-driver@qlogic.com, jejb <james.bottomley@steeleye.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointers (sparse warning):
drivers/scsi/qla2xxx/qla_attr.c:393:4: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19-rc6-git10.orig/drivers/scsi/qla2xxx/qla_attr.c
+++ linux-2.6.19-rc6-git10/drivers/scsi/qla2xxx/qla_attr.c
@@ -390,7 +390,7 @@ static struct sysfs_entry {
 	{ "optrom_ctl", &sysfs_optrom_ctl_attr, },
 	{ "vpd", &sysfs_vpd_attr, 1 },
 	{ "sfp", &sysfs_sfp_attr, 1 },
-	{ 0 },
+	{ NULL },
 };
 
 void


---
