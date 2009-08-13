From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 5/6] RFC: beiscsi: Makefile and Kconfig
Date: Thu, 13 Aug 2009 12:42:43 +0530
Message-ID: <20090813071233.GA29148@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:59547 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753148AbZHMHMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2009 03:12:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The Makefile and Kconfig for beiscsi driver

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/beiscsi/Kconfig  |    8 ++++++++
 drivers/scsi/beiscsi/Makefile |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/beiscsi/Kconfig
 create mode 100755 drivers/scsi/beiscsi/Makefile

diff --git a/drivers/scsi/beiscsi/Kconfig b/drivers/scsi/beiscsi/Kconfig
new file mode 100644
index 0000000..2952fcd
--- /dev/null
+++ b/drivers/scsi/beiscsi/Kconfig
@@ -0,0 +1,8 @@
+config BE2ISCSI
+	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
+	depends on PCI && SCSI
+	select SCSI_ISCSI_ATTRS
+
+	help
+	This driver implements the iSCSI functionality for ServerEngines'
+	10Gbps Storage adapter - BladeEngine 2.
diff --git a/drivers/scsi/beiscsi/Makefile b/drivers/scsi/beiscsi/Makefile
new file mode 100755
index 0000000..c11f443
--- /dev/null
+++ b/drivers/scsi/beiscsi/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile to build the iSCSI driver for ServerEngine's BladeEngine.
+#
+#
+
+obj-$(CONFIG_BE2ISCSI) += be2iscsi.o
+
+be2iscsi-y := be_iscsi.o be_main.o be_mgmt.o be_cmds.o
-- 
1.6.3

