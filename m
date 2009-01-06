From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 18/18] scsi: Add osd library to build system
Date: Tue,  6 Jan 2009 16:34:08 +0200
Message-ID: <1231252448-32731-1-git-send-email-bharrosh@panasas.com>
References: <49636507.8060808@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:24791 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751881AbZAFOeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 09:34:11 -0500
In-Reply-To: <49636507.8060808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

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
index ceb32ee..3dcc11c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3241,6 +3241,16 @@ L:	orinoco-devel@lists.sourceforge.net
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
index 152d4aa..7cadcf8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1802,4 +1802,6 @@ source "drivers/scsi/pcmcia/Kconfig"
 
 source "drivers/scsi/device_handler/Kconfig"
 
+source "drivers/scsi/osd/Kconfig"
+
 endmenu
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1410697..ec2be4e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -138,6 +138,8 @@ obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
+obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
+
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
-- 
1.6.0.1

