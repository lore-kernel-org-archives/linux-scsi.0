From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi/fc: fix function declarations to be ANSI-compliant
Date: Mon, 27 Apr 2009 21:49:31 -0700
Message-ID: <49F68ADB.6010901@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:21919 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZD1EsT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2009 00:48:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix scsi/fc function declarations:

drivers/scsi/fcoe/fcoe.c:1356:28: warning: non-ANSI function declaration of function 'fcoe_dev_setup'
drivers/scsi/libfc/fc_rport.c:1293:20: warning: non-ANSI function declaration of function 'fc_setup_rport'
drivers/scsi/libfc/fc_rport.c:1302:23: warning: non-ANSI function declaration of function 'fc_destroy_rport'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/fcoe/fcoe.c      |    2 +-
 drivers/scsi/libfc/fc_rport.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- mmotm-2009-0427-1545.orig/drivers/scsi/fcoe/fcoe.c
+++ mmotm-2009-0427-1545/drivers/scsi/fcoe/fcoe.c
@@ -1353,7 +1353,7 @@ out:
 /**
  * fcoe_dev_setup() - setup link change notification interface
  */
-static void fcoe_dev_setup()
+static void fcoe_dev_setup(void)
 {
 	/*
 	 * here setup a interface specific wd time to
--- mmotm-2009-0427-1545.orig/drivers/scsi/libfc/fc_rport.c
+++ mmotm-2009-0427-1545/drivers/scsi/libfc/fc_rport.c
@@ -1290,7 +1290,7 @@ int fc_rport_init(struct fc_lport *lport
 }
 EXPORT_SYMBOL(fc_rport_init);
 
-int fc_setup_rport()
+int fc_setup_rport(void)
 {
 	rport_event_queue = create_singlethread_workqueue("fc_rport_eq");
 	if (!rport_event_queue)
@@ -1299,7 +1299,7 @@ int fc_setup_rport()
 }
 EXPORT_SYMBOL(fc_setup_rport);
 
-void fc_destroy_rport()
+void fc_destroy_rport(void)
 {
 	destroy_workqueue(rport_event_queue);
 }
