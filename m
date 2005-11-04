From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI_AACRAID: add a help text
Date: Fri, 4 Nov 2005 02:01:23 +0100
Message-ID: <20051104010123.GA5587@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53764 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932699AbVKDBBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Nov 2005 20:01:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.6/drivers/scsi/Kconfig.old        2004-05-17 20:51:21.395075352 -0500
+++ linux-2.6.6/drivers/scsi/Kconfig    2004-05-17 20:55:52.074925760 -0500
@@ -315,6 +315,13 @@
 config SCSI_AACRAID
 	tristate "Adaptec AACRAID support"
 	depends on SCSI && PCI
+	help
+	  This driver supports the Dell PERC2, 2/Si, 3/Si, 3/Di,
+	  HP NetRAID-4M SCSI and the Adaptec Advanced Raid Products
+	  <http://www.adaptec.com/products/solutions/raid.html>
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called aacraid.

 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"


