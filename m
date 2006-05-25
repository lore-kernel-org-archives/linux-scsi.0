From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] megaraid_mbox: fix section mismatch warnings
Date: Thu, 25 May 2006 09:46:14 -0700
Message-ID: <20060525094614.d2927f2a.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:45233 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030269AbWEYQnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 12:43:41 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 09:43:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?B?X19zbWFpbCBE9m5tZXo=?= <ismail@pardus.org.tr>, scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, jejb <james.bottomley@steeleye.com>, Neela.Kolli@engenio.com

From: Randy Dunlap <rdunlap@xenotime.net>

Fix section warning:
WARNING: drivers/scsi/megaraid/megaraid_mbox.o - Section mismatch: reference to .init.text: from .text between 'megaraid_probe_one' (at offset 0x171e) and 'megaraid_queue_command'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/megaraid/megaraid_mbox.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2617-rc5.orig/drivers/scsi/megaraid/megaraid_mbox.c
+++ linux-2617-rc5/drivers/scsi/megaraid/megaraid_mbox.c
@@ -714,7 +714,7 @@ megaraid_io_detach(adapter_t *adapter)
  * . Allocate memory required for all the commands
  * . Use internal library of FW routines, build up complete soft state
  */
-static int __init
+static int __devinit
 megaraid_init_mbox(adapter_t *adapter)
 {
 	struct pci_dev		*pdev;


---
