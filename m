From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] SCSI:  Remove apparently unused traces of SCSI_QLOGIC_FC
 content.
Date: Sat, 27 Oct 2007 00:36:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710270032170.30030@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:46626 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXJ0EjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 00:39:19 -0400
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IldSB-0006hi-7f
	for linux-scsi@vger.kernel.org; Sat, 27 Oct 2007 00:39:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  i can't find any historical evidence that the related content has
been removed, but nothing in the tree seems to need this Kconfig
entry (and, as randy dunlap noticed, the dependency of SCSI_QLOGIC_FC
doesn't even exist, anyway).


diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a5763c6..a0b9c67 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1319,14 +1319,6 @@ config SCSI_QLOGIC_FAS
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
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
