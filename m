From: "Maxin B. John" <maxin.john@gmail.com>
Subject: [PATCH] SCSI: OSD: Kconfig: Select SHA1 and HMAC for OSD Initiator
 library
Date: Thu, 11 Aug 2011 17:27:50 +0300
Message-ID: <20110811142749.GA26109@maxin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40635 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1HKO1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 10:27:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rdunlap@xenotime.net
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

SCSI_OSD_INITIATOR should select CRYPTO_SHA1 and CRYPTO_HMAC. Express this
in Kconfig so that the requirements are met automatically. 

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
index 861b5ce..1535fe1 100644
--- a/drivers/scsi/osd/Kconfig
+++ b/drivers/scsi/osd/Kconfig
@@ -11,17 +11,16 @@
 # it under the terms of the GNU General Public version 2 License as
 # published by the Free Software Foundation
 #
-# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
-#        How is it done properly?
 #
 
 config SCSI_OSD_INITIATOR
 	tristate "OSD-Initiator library"
 	depends on SCSI
+	select CRYPTO
+	select CRYPTO_SHA1
+	select CRYPTO_HMAC
 	help
 		Enable the OSD-Initiator library (libosd.ko).
-		NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
-		dependencies
 
 config SCSI_OSD_ULD
 	tristate "OSD Upper Level driver"
