From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 17/19] be2iscsi: patch from Randy Dunlap
Date: Thu, 22 Jul 2010 04:29:58 +0530
Message-ID: <20100721225949.GA9808@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:25906 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754192Ab0GUW7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:59:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch add NET because be2iscsi is using sysfs_format_mac function
  Found and patch originally submitted by Randy Dunlap

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/Kconfig   |    2 +-
 drivers/scsi/be2iscsi/be_main.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/Kconfig b/drivers/scsi/be2iscsi/Kconfig
index 2952fcd..9d57142 100644
--- a/drivers/scsi/be2iscsi/Kconfig
+++ b/drivers/scsi/be2iscsi/Kconfig
@@ -1,7 +1,7 @@
 config BE2ISCSI
 	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
 	depends on PCI && SCSI
-	select SCSI_ISCSI_ATTRS
+	select SCSI_ISCSI_ATTRS && NET
 
 	help
 	This driver implements the iSCSI functionality for ServerEngines'
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index b38af64..48b7d4d 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/if_ether.h>
 #include <linux/in.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-- 
1.6.5.2

