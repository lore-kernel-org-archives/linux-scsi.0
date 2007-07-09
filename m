From: akpm@linux-foundation.org
Subject: [patch 15/17] remove the dead CYBERSTORMIII_SCSI option
Date: Mon, 09 Jul 2007 12:00:10 -0700
Message-ID: <200707091900.l69J0Aq5002555@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278AbXGITHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:07:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

Not converted to the 2.6 kconfig system and no code in the tree.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/scsi/Kconfig~remove-the-dead-cyberstormiii_scsi-option drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~remove-the-dead-cyberstormiii_scsi-option
+++ a/drivers/scsi/Kconfig
@@ -1780,8 +1780,6 @@ config SCSI_SUNESP
 	  To compile this driver as a module, choose M here: the
 	  module will be called esp.
 
-#      bool 'Cyberstorm Mk III SCSI support (EXPERIMENTAL)' CONFIG_CYBERSTORMIII_SCSI
-
 config ZFCP
 	tristate "FCP host bus adapter driver for IBM eServer zSeries"
 	depends on S390 && QDIO && SCSI
_
