From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Mark correct aha152x driver (PCMCIA) as !64BIT
Date: Tue, 7 Oct 2003 20:05:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007180522.GA2280@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:43780 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S262553AbTJGSFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 14:05:25 -0400
Received: from fred.muc.de (Hannibal_Hunsiker@localhost.localdomain [127.0.0.1])
	by zero.aec.at (8.11.6/8.11.2) with ESMTP id h97I5IS22732
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 20:05:19 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


As Matthew Wilcox pointed out - the ISA aha152x driver was already marked
as ISA only, so couldn't have been enabled on x86-64.

The warning I saw was actually for the PCMCIA aha152x driver.

Mark that one as !64BIT

--- linux-2.5-cleanup/drivers/scsi/pcmcia/Kconfig-o	2003-09-28 06:33:48.000000000 +0200
+++ linux-2.5-cleanup/drivers/scsi/pcmcia/Kconfig	2003-12-02 18:15:03.414452576 +0100
@@ -7,7 +7,7 @@
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
-	depends on m
+	depends on m && !64BIT
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
