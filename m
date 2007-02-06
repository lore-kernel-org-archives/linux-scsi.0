From: akpm@linux-foundation.org
Subject: [patch 19/33] scsi: sic7xxx stray bracket fix
Date: Mon, 05 Feb 2007 16:38:53 -0800
Message-ID: <200702060039.l160dubN005008@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41772 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965333AbXBFAkA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Fix broken-but-unused macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-sic7xxx-stray-bracket-fix drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-sic7xxx-stray-bracket-fix
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -88,7 +88,7 @@ ahd_compose_id(u_int device, u_int vendo
 
 #define SUBID_9005_LEGACYCONN_FUNC(id) ((id) & 0x20)
 
-#define SUBID_9005_SEEPTYPE(id) ((id) & 0x0C0) >> 6)
+#define SUBID_9005_SEEPTYPE(id) (((id) & 0x0C0) >> 6)
 #define		SUBID_9005_SEEPTYPE_NONE	0x0
 #define		SUBID_9005_SEEPTYPE_4K		0x1
 
_
