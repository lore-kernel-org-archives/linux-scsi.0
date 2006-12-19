From: akpm@osdl.org
Subject: [patch 22/26] scsi: sic7xxx stray bracket fix
Date: Tue, 19 Dec 2006 13:14:57 -0800
Message-ID: <200612192114.kBJLEvG5010746@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36098 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbWLSVPG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 16:15:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, m.kozlowski@tuxland.pl

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Fix broken-but-unused macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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
