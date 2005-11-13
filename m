From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] scsi: remove usage of proc_name from scsi_host_alloc
Date: Sun, 13 Nov 2005 17:17:03 +0100 (CET)
Message-ID: <200511131619.jADGJFwQ032002@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50391 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964926AbVKMQTb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 11:19:31 -0500
Received: from s5r6.in-berlin.de ([83.221.230.151])
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id jADGJFwQ032002
	for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2005 17:19:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_host_alloc: use host template's .name instead of .proc_name in order to
restrict usage of .proc_name to procfs and sysfs

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/scsi/hosts.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.14-git3/drivers/scsi/hosts.c.orig	2005-10-31 12:27:21.000000000 +0100
+++ linux-2.6.14-git3/drivers/scsi/hosts.c	2005-11-13 16:06:26.000000000 +0100
@@ -301,7 +301,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 				"ERROR: This is not a safe way to run your "
 				        "SCSI host\n"
 				"ERROR: The error handling must be added to "
-				"this driver\n", sht->proc_name);
+				"this driver\n", sht->name);
 		dump_stack();
         }
 

