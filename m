From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] scsi: aha152x pcmcia driver needs spi transport
Date: Sun, 5 Mar 2006 11:42:06 +0100
Message-ID: <20060305104206.GA22487@isilmar.linta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.239.214.66]:23754 "EHLO linta.de")
	by vger.kernel.org with ESMTP id S932186AbWCEKmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Mar 2006 05:42:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, fischer@norbit.de

AHA152X PCMCIA module needs spi_print_msg.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index df52190..eac8e17 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -8,6 +8,7 @@ menu "PCMCIA SCSI adapter support"
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
 	depends on m && !64BIT
+	select SCSI_SPI_ATTRS
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
