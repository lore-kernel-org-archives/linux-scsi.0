From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] remove the dead CYBERSTORMIII_SCSI option
Date: Tue, 19 Jun 2007 22:26:42 +0200
Message-ID: <20070619202642.GF12950@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33665 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934034AbXFSU0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 16:26:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Not converted to the 2.6 kconfig system and no code in the tree.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/drivers/scsi/Kconfig.old	2007-06-18 15:22:55.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/scsi/Kconfig	2007-06-18 15:23:04.000000000 +0200
@@ -1774,8 +1774,6 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called esp.
 
-#      bool 'Cyberstorm Mk III SCSI support (EXPERIMENTAL)' CONFIG_CYBERSTORMIII_SCSI
-
 config ZFCP
 	tristate "FCP host bus adapter driver for IBM eServer zSeries"
 	depends on S390 && QDIO && SCSI

