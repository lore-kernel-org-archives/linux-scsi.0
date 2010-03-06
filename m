From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] scsi: PCMCIA_AHA152X might not need to depend on !64BIT
Date: Sat, 6 Mar 2010 15:20:46 +0100
Message-ID: <20100306142046.GA23104@comet.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:47839 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752163Ab0CFOUx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Mar 2010 09:20:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mithrandir@loeb-it.de

As per http://bugzilla.kernel.org/show_bug.cgi?id=14333, the aha152x
pcmcia driver works fine also on 64bit architectures.

NOTE: I haven't reviewed or checked it out myself.

CC: mithrandir@loeb-it.de
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index 53857c6..ecc855c 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -11,7 +11,6 @@ if SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCIA && m
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
-	depends on !64BIT
 	select SCSI_SPI_ATTRS
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
