From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] postfix a constat in mptbase.c with ULL
Date: Mon, 30 Jun 2003 22:44:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030630204429.GK282@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:23499 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S265878AbTF3UaP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2003 16:30:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Pam.Delaney@lsil.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, trivial@rustcorp.com.au


The patch below postfixes a constant in mptbase.c that is on 32 bit 
archs too big for a long with ULL.

Please apply
Adrian

--- linux-2.5.73-not-full/drivers/message/fusion/mptbase.c.old	2003-06-23 23:07:57.000000000 +0200
+++ linux-2.5.73-not-full/drivers/message/fusion/mptbase.c	2003-06-23 23:08:27.000000000 +0200
@@ -1279,7 +1279,7 @@
 	u32		 psize;
 	int		 ii;
 	int		 r = -ENODEV;
-	u64		 mask = 0xffffffffffffffff;
+	u64		 mask = 0xffffffffffffffffULL;
 
 	if (pci_enable_device(pdev))
 		return r;
