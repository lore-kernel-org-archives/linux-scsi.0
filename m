From: Rusty Trivial Russell <trivial@rustcorp.com.au>
Subject: [TRIVIAL] Re: Remove modules.txt drivers_scsi_pcmcia_Kconfig
Date: Thu, 11 Sep 2003 16:40:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911064500.349942C4C0@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:42429 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S266187AbTIKGpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 02:45:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

From:  Nicolas Kaiser <nikai@nikai.net>

  Cheers, n.

--- trivial-2.6.0-test5-bk1/drivers/scsi/pcmcia/Kconfig.orig	2003-09-11 16:25:30.000000000 +1000
+++ trivial-2.6.0-test5-bk1/drivers/scsi/pcmcia/Kconfig	2003-09-11 16:25:30.000000000 +1000
@@ -12,10 +12,8 @@
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
 
-	  This driver is also available as a module called aha152x_cs ( =
-	  code which can be inserted in and removed from the running kernel
-	  whenever you want). If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called aha152x_cs.
 
 config PCMCIA_FDOMAIN
 	tristate "Future Domain PCMCIA support"
@@ -24,10 +22,8 @@
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
 
-	  This driver is also available as a module called fdomain_cs ( =
-	  code which can be inserted in and removed from the running kernel
-	  whenever you want).  If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called fdomain_cs.
 
 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
@@ -60,10 +56,8 @@
 	    HP M820e CDRW's card
 	    etc.
 
-	  This driver is also available as a module called nsp_cs ( =
-	  code which can be inserted in and removed from the running kernel
-	  whenever you want). If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called nsp_cs.
 
 config PCMCIA_QLOGIC
 	tristate "Qlogic PCMCIA support"
@@ -72,9 +66,7 @@
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
 
-	  This driver is also available as a module called qlogic_cs ( =
-	  code which can be inserted in and removed from the running kernel
-	  whenever you want).  If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called qlogic_cs.
 
 endmenu
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Nicolas Kaiser <nikai@nikai.net>: Re: [PATCH] Remove modules.txt drivers_scsi_pcmcia_Kconfig
