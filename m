From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] fix changed doc. location
Date: Sat, 24 Jan 2004 22:04:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040124220440.7297b0b0.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57269 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263695AbUAYGes (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2004 01:34:48 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb <james.bottomley@steeleye.com>


Hi,
Please apply to 2.6.current.

Thanks,
--
~Randy


From: Jean Delvare <khali@linux-fr.org>


Hi Linus, hi all,

A very simple patch against 2.6.0 follows, which fixes an improper file
reference in the scsi sym53c8xx_2 driver help text. The referenced
documentation file was moved in 2.5.48 but the help text was not updated
accordingly.

Please apply.
And thanks a lot for the excellent work :)

 drivers/scsi/Kconfig.orig                       |    0 

diff -puN drivers/scsi/Kconfig~scsi_config_doc drivers/scsi/Kconfig


 linux-262-rc1-bk1-rddunlap/drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~scsi_config_doc drivers/scsi/Kconfig
--- linux-262-rc1-bk1/drivers/scsi/Kconfig~scsi_config_doc	2004-01-23 15:52:42.000000000 -0800
+++ linux-262-rc1-bk1-rddunlap/drivers/scsi/Kconfig	2004-01-23 15:52:42.000000000 -0800
@@ -903,7 +903,7 @@ config SCSI_SYM53C8XX_2
 	  language.  It does not support LSI53C10XX Ultra-320 PCI-X SCSI
 	  controllers; you need to use the Fusion MPT driver for that.
 
-	  Please read <file:drivers/scsi/sym53c8xx_2/Documentation.txt> for more
+	  Please read <file:Documentation/scsi/sym53c8xx_2.txt> for more
 	  information.
 
 config SCSI_SYM53C8XX_DMA_ADDRESSING_MODE

_
