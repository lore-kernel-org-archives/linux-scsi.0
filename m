From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Mark Ninja SCSI driver as !64BIT
Date: Tue, 7 Oct 2003 19:31:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007173146.GA1598@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:18436 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S262546AbTJGRbt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 13:31:49 -0400
Received: from fred.muc.de (Bartle_Quinker@localhost.localdomain [127.0.0.1])
	by zero.aec.at (8.11.6/8.11.2) with ESMTP id h97HVgS22474
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 19:31:43 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Ninjas don't seem to like 64bit. The driver spew out so many 
integer/pointer mismatch warnings that I gave up.

Mark it as !64BIT

-Andi

diff -u linux-2.5-cleanup/drivers/scsi/pcmcia/Kconfig-o linux-2.5-cleanup/drivers/scsi/pcmcia/Kconfig
--- linux-2.5-cleanup/drivers/scsi/pcmcia/Kconfig-o	2003-09-28 06:33:48.000000000 +0200
+++ linux-2.5-cleanup/drivers/scsi/pcmcia/Kconfig	2003-12-02 16:57:35.986968944 +0100
@@ -27,7 +27,7 @@
 
 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
-	depends on m
+	depends on m && !64BIT
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
 	  your computer, say Y here and read
