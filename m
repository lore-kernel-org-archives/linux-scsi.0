From: akpm@osdl.org
Subject: [patch 08/26] remove extra newline from info message
Date: Tue, 19 Dec 2006 13:14:43 -0800
Message-ID: <200612192114.kBJLEiP0010697@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979AbWLSVO4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 16:14:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, eike-kernel@sf-tec.de

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

remove extra newline from info message

This extra newline character introduces a completely empty line in dmesg as
the calling function itself adds a newline.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~remove-extra-newline-from-info-message drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~remove-extra-newline-from-info-message
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -418,7 +418,6 @@ ahd_linux_info(struct Scsi_Host *host)
 	strcat(bp, "        ");
 	ahd_controller_info(ahd, ahd_info);
 	strcat(bp, ahd_info);
-	strcat(bp, "\n");
 
 	return (bp);
 }
_
