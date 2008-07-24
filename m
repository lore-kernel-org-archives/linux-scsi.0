From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 14/14] scsi: Add osd library to build system
Date: Thu, 24 Jul 2008 21:03:31 +0300
Message-ID: <4888C3F3.3080409@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24387 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbYGXSEI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 14:04:08 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


OSD in kernel source code is assumed to be at:
drivers/scsi/osd/ with its own Makefile and Kconfig

Add includes to them from drivers/scsi Makefile and Kconfig
Add osd to MAINTAINERS file

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 MAINTAINERS           |   10 ++++++++++
 drivers/scsi/Kconfig  |    2 ++
 drivers/scsi/Makefile |    2 ++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93fd6b2..814d5b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3137,6 +3137,16 @@ L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
 
+OSD LIBRARY
+P:	Boaz Harrosh
+M:	bharrosh@panasas.com
+P:	Benny Halevy
+M:	bhalevy@panasas.com
+L:	osd-dev@open-osd.org
+W:	http://open-osd.org
+T:	git://git.open-osd.org/osd-lib.git
+S:	Maintained
+
 PA SEMI ETHERNET DRIVER
 P:	Olof Johansson
 M:	olof@lixom.net
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c7f0629..60a7e3a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1795,4 +1795,6 @@ source "drivers/scsi/pcmcia/Kconfig"
 
 source "drivers/scsi/device_handler/Kconfig"
 
+source "drivers/scsi/osd/Kconfig"
+
 endmenu
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 72fd504..1e49632 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -135,6 +135,8 @@ obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
+obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
+
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
-- 
1.5.6.rc1.5.gadf6


