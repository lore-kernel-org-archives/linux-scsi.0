From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] SCSI: enable PCMCIA AHA152X on 64bit
Date: Fri, 24 Sep 2010 22:07:51 +0200
Message-ID: <1285358871-31221-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>, Andi Kleen <andi@firstfloor.org>, "Juergen E. Fischer" <fischer@norbit.de>
List-Id: linux-scsi@vger.kernel.org

It was disabled when x86_64 was introduced, but it is reported to be
working on 64bit by two different people, so let's enable it back
again.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "Juergen E. Fischer" <fischer@norbit.de>
---
 drivers/scsi/pcmcia/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
-- 
1.7.2.2
