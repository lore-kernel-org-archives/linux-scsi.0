From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi menu: move RAID transport class to Transports menu
Date: Sun, 4 Nov 2007 10:44:23 -0800
Message-ID: <20071104104423.d595c0e7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:29118 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbXKDSpE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 13:45:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Move RAID_ATTRS into the SCSI Transports sub-menu.
Fix some help text whitespace in Transports.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/Kconfig |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.24-rc1-git13.orig/drivers/scsi/Kconfig
+++ linux-2.6.24-rc1-git13/drivers/scsi/Kconfig
@@ -1,12 +1,5 @@
 menu "SCSI device support"
 
-config RAID_ATTRS
-	tristate "RAID Transport Class"
-	default n
-	depends on BLOCK
-	---help---
-	  Provides RAID
-
 config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
@@ -256,6 +249,13 @@ config SCSI_WAIT_SCAN
 menu "SCSI Transports"
 	depends on SCSI
 
+config RAID_ATTRS
+	tristate "RAID Transport Class"
+	default n
+	depends on BLOCK
+	---help---
+	  Provides RAID class information in sysfs.
+
 config SCSI_SPI_ATTRS
 	tristate "Parallel SCSI (SPI) Transport Attributes"
 	depends on SCSI
@@ -277,7 +277,7 @@ config SCSI_FC_TGT_ATTRS
 	depends on SCSI_FC_ATTRS
 	depends on SCSI_TGT = y || SCSI_TGT = SCSI_FC_ATTRS
 	help
-		If you want to use SCSI target mode drivers enable this option.
+	  If you want to use SCSI target mode drivers enable this option.
 
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
@@ -308,7 +308,7 @@ config SCSI_SRP_TGT_ATTRS
 	depends on SCSI_SRP_ATTRS
 	depends on SCSI_TGT = y || SCSI_TGT = SCSI_SRP_ATTRS
 	help
-		If you want to use SCSI target mode drivers enable this option.
+	  If you want to use SCSI target mode drivers enable this option.
 
 endmenu
 
