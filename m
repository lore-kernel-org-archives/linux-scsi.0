From: akpm@linux-foundation.org
Subject: [patch 12/18] scsi: remove the unused SCSI_QLOGIC_FC_FIRMWARE option
Date: Wed, 20 Aug 2008 16:55:32 -0700
Message-ID: <200808202355.m7KNtWqM006215@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbYHUADm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2008 20:03:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org, rpjday@crashcourse.ca

From: Adrian Bunk <bunk@kernel.org>

This option was forgotten when the SCSI_QLOGIC_FC driver was removed.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/scsi/Kconfig~scsi-remove-the-unused-scsi_qlogic_fc_firmware-option drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-remove-the-unused-scsi_qlogic_fc_firmware-option
+++ a/drivers/scsi/Kconfig
@@ -1336,14 +1336,6 @@ config SCSI_QLOGIC_FAS
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicfas.
 
-config SCSI_QLOGIC_FC_FIRMWARE
-	bool "Include loadable firmware in driver"
-	depends on SCSI_QLOGIC_FC
-  	help
-	  Say Y to include ISP2X00 Fabric Initiator/Target Firmware, with
-	  expanded LUN addressing and FcTape (FCP-2) support, in the
-	  qlogicfc driver. This is required on some platforms.
-
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
 	depends on PCI && SCSI
_
