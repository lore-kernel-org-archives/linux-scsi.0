From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] fix JAZZ_ESP driver config depends
Date: Wed, 30 Jun 2004 10:43:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040630104346.7a2fc8dd.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:54195 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266785AbUF3Rra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 13:47:30 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


Use correct config symbol name for MACH_JAZZ in JAZZ_ESP driver config.
Acked by Ralf.

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>


diffstat:=
 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp ./drivers/scsi/Kconfig~scsi_mips_jazz ./drivers/scsi/Kconfig
--- ./drivers/scsi/Kconfig~scsi_mips_jazz	2004-06-29 10:09:25.000000000 -0700
+++ ./drivers/scsi/Kconfig	2004-06-30 09:35:11.845356752 -0700
@@ -1507,7 +1507,7 @@ source "drivers/scsi/arm/Kconfig"
 
 config JAZZ_ESP
 	bool "MIPS JAZZ FAS216 SCSI support"
-	depends on MIPS_JAZZ && SCSI
+	depends on MACH_JAZZ && SCSI
 	help
 	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
 	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM


--
~Randy
