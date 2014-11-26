From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: improve driver description in Kconfig
Date: Wed, 26 Nov 2014 14:55:24 -0500
Message-ID: <5476302C.9050509@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000609030302070106080202"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41171 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaKZTzl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 14:55:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

This is a multi-part message in MIME format.
--------------000609030302070106080202
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

From: Douglas Gilbert <dgilbert@interlog.com>
Date: Wed, 26 Nov 2014 14:41:55 -0500
Subject: [PATCH] scsi_debug improve driver description in Kconfig

Try to give a more accurate driver description and some extra
useful information in less lines.
---
  drivers/scsi/Kconfig | 17 ++++++++---------
  1 file changed, 8 insertions(+), 9 deletions(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------000609030302070106080202
Content-Type: text/x-patch;
 name="0001-scsi_debug-improve-driver-description-in-Kconfig.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi_debug-improve-driver-description-in-Kconfig.patch"

>From a9a36335e3983eaa229fa4c1d79253977eed9dc6 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Wed, 26 Nov 2014 14:41:55 -0500
Subject: [PATCH] scsi_debug improve driver description in Kconfig

Try to give a more accurate driver description and some extra
useful information in less lines.
---
 drivers/scsi/Kconfig | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 86cf3d6..2e3a661 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1462,18 +1462,17 @@ config SCSI_WD719X
 	  SCSI controllers (based on WD33C296A chip).
 
 config SCSI_DEBUG
-	tristate "SCSI debugging host simulator"
+	tristate "SCSI debugging host and device simulator"
 	depends on SCSI
 	select CRC_T10DIF
 	help
-	  This is a host adapter simulator that can simulate multiple hosts
-	  each with multiple dummy SCSI devices (disks). It defaults to one
-	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
-	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
-	  dummy disks are simulated, they share the same kernel RAM for 
-	  their storage. See <http://sg.danny.cz/sg/sdebug26.html> for more
-	  information. This driver is primarily of use to those testing the
-	  SCSI and block subsystems. If unsure, say N.
+	  This pseudo driver simulates one or more hosts (SCSI initiators),
+	  each with one or more targets, each with one or more logical units.
+	  Defaults to one of each, creating a small ram disk device. Many
+	  parameters found in the /sys/bus/pseudo/drivers/scsi_debug
+	  directory can be tweaked at run time.
+	  See <http://sg.danny.cz/sg/sdebug26.html> for more information.
+	  Mainly used for testing and best as a module. If unsure, say N.
 
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
-- 
1.9.1


--------------000609030302070106080202--
