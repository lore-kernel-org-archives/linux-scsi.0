From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] let "PCMCIA SCSI adapter support" menu depend on MODULES
Date: Thu, 4 Sep 2003 01:23:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030903232334.GL18025@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@rustcorp.com.au
List-Id: linux-scsi@vger.kernel.org

When configuring a kernel without modules support "PCMCIA SCSI adapter 
support" is a menu with no available items in it (all drivers depend on 
"m").

The patch below only shows this menu when MODULES is enabled.

Please apply
Adrian

--- linux-2.6.0-test4-mm5/drivers/scsi/pcmcia/Kconfig.old	2003-09-04 01:18:17.000000000 +0200
+++ linux-2.6.0-test4-mm5/drivers/scsi/pcmcia/Kconfig	2003-09-04 01:19:03.000000000 +0200
@@ -3,7 +3,7 @@
 #
 
 menu "PCMCIA SCSI adapter support"
-	depends on SCSI!=n && PCMCIA!=n
+	depends on SCSI!=n && PCMCIA!=n && MODULES
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
