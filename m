From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 16/16] scsi: Add osd library to build system
Date: Sun, 25 Jan 2009 17:24:14 +0200
Message-ID: <1232897054-19933-1-git-send-email-bharrosh@panasas.com>
References: <497C7B33.4080105@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:27729 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755154AbZAYPYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 10:24:18 -0500
In-Reply-To: <497C7B33.4080105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

OSD in kernel source code is assumed to be at:
drivers/scsi/osd/ with its own Makefile and Kconfig

Add includes to them from drivers/scsi Makefile and Kconfig
Add OSD to MAINTAINERS file

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 MAINTAINERS           |   10 ++++++++++
 drivers/scsi/Kconfig  |    2 ++
 drivers/scsi/Makefile |    2 ++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f65a26..3d05091 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3260,6 +3260,16 @@ L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
 
+OSD LIBRARY
+P:	Boaz Harrosh
+M:	bharrosh@panasas.com
+P:	Benny Halevy
+M:	bhalevy@panasas.com
+L:	osd-dev@open-osd.org
+W:	http://open-osd.org
+T:	git://git.open-osd.org/open-osd.git
+S:	Maintained
+
 P54 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 601c2a8..e420ad0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1806,4 +1806,6 @@ source "drivers/scsi/pcmcia/Kconfig"
 
 source "drivers/scsi/device_handler/Kconfig"
 
+source "drivers/scsi/osd/Kconfig"
+
 endmenu
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 7461eb0..05558b1 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -137,6 +137,8 @@ obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
+obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
+
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
-- 
1.6.0.1

