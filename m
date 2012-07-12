From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] aha152x: Allow use on 64bit systems
Date: Thu, 12 Jul 2012 16:40:15 +0100
Message-ID: <20120712154005.18962.59464.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59871 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab2GLPXc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2012 11:23:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com

From: Alan Cox <alan@linux.intel.com>

This is reported to work, known to work on PCMCIA and a code check shows no
problems on the other bits of the code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6c810db..74bf1aa 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -444,7 +444,7 @@ config SCSI_ACARD
 
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
-	depends on ISA && SCSI && !64BIT
+	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
 	select CHECK_SIGNATURE
 	---help---

