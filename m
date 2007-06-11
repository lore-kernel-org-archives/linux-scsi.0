From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi_debug: correct parameter default text
Date: Mon, 11 Jun 2007 11:36:40 -0700
Message-ID: <20070611113640.a2ec2afd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:34276 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbXFKSgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2007 14:36:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, jejb <james.bottomley@steeleye.com>
Cc: scsi <linux-scsi@vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Correct the module info text for the default value of
"every_nth" to 0.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2622-rc4.orig/drivers/scsi/scsi_debug.c
+++ linux-2622-rc4/drivers/scsi/scsi_debug.c
@@ -2405,7 +2405,7 @@ MODULE_PARM_DESC(add_host, "0..127 hosts
 MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
 MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
-MODULE_PARM_DESC(every_nth, "timeout every nth command(def=100)");
+MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
