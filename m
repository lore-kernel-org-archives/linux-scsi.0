From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 01/18] major.h: char-major number for OSD device driver
Date: Tue,  4 Nov 2008 18:17:00 +0200
Message-ID: <1225815420-5721-1-git-send-email-bharrosh@panasas.com>
References: <491073BB.4000900@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:42539 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYKDQUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 11:20:04 -0500
In-Reply-To: <491073BB.4000900@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torben Mathiasen <device@lanana.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>

We need a major for a char device for our OSD device driver.
Attached is a proposed patch for the Documentation/devices.txt
and include/linux/major.h files.

I have allocated the *260* char device as it looked like the next
available on the lanana.org web-site
(http://lanana.org/docs/device-list/devices-2.6+.txt)

Any number will do. Please allocate a number for us

(See http:/open-osd.org for further information)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Torben Mathiasen <device@lanana.org>
---
 Documentation/devices.txt |    6 ++++++
 include/linux/major.h     |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 05c8064..d18070b 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -3142,6 +3142,12 @@ Your cooperation is appreciated.
 		  1 = /dev/blockrom1	Second ROM card's translation layer interface
 		  ...
 
+260 char	OSD (Object-based-device) SCSI Device
+		  0 = /dev/osd0		First OSD Device
+		  1 = /dev/osd1		Second OSD Device
+		  ...
+		  255 = /dev/osd255	256th OSD Device
+
  ****	ADDITIONAL /dev DIRECTORY ENTRIES
 
 This section details additional entries that should or may exist in
diff --git a/include/linux/major.h b/include/linux/major.h
index 8824945..058ec15 100644
--- a/include/linux/major.h
+++ b/include/linux/major.h
@@ -171,5 +171,6 @@
 #define VIOTAPE_MAJOR		230
 
 #define BLOCK_EXT_MAJOR		259
+#define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device */
 
 #endif
-- 
1.6.0.1

