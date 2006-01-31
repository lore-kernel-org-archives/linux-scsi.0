From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI_AACRAID: add a help text
Date: Tue, 31 Jan 2006 22:32:57 +0100
Message-ID: <20060131213257.GE3986@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:19471 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1751511AbWAaVdB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 16:33:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Most of the text by Mark Salyzyn <mark_salyzyn@adaptec.com>.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/Kconfig |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.16-rc1-mm4-full/drivers/scsi/Kconfig.old	2006-01-31 21:18:27.000000000 +0100
+++ linux-2.6.16-rc1-mm4-full/drivers/scsi/Kconfig	2006-01-31 21:19:48.000000000 +0100
@@ -381,6 +381,14 @@
 config SCSI_AACRAID
 	tristate "Adaptec AACRAID support"
 	depends on SCSI && PCI
+	help
+	  This driver supports a variety of Dell, HP, Adaptec, IBM and
+	  ICP storage products. For a list of supported products, refer
+	  to <file:Documentation/scsi/aacraid.txt>.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called aacraid.
+
 
 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
 

