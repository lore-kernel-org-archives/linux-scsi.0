From: akpm@linux-foundation.org
Subject: [patch 05/30] remove extra newline from info message
Date: Fri, 16 Feb 2007 01:46:24 -0800
Message-ID: <200702160946.l1G9kOGQ026630@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36789 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423500AbXBPJqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:46:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, eike-kernel@sf-tec.de

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

remove extra newline from info message

This extra newline character introduces a completely empty line in dmesg as
the calling function itself adds a newline.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c |    1 -
 1 file changed, 1 deletion(-)

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
