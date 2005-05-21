From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] aic7xxx: unmix declarations and code
Date: Sat, 21 May 2005 17:04:13 +0400
Message-ID: <200505211704.13874.adobriyan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.196]:36243 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261733AbVEUNAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 09:00:00 -0400
Received: by wproxy.gmail.com with SMTP id 69so187845wri
        for <linux-scsi@vger.kernel.org>; Sat, 21 May 2005 05:59:59 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

--- linux-20050521140543-000/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-21 14:11:06.000000000 +0400
+++ linux-20050521140543-001/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-21 16:49:32.000000000 +0400
@@ -659,8 +659,10 @@ ahc_linux_slave_alloc(struct scsi_device
 	ahc_lock(ahc, &flags);
 	targ = ahc->platform_data->targets[target_offset];
 	if (targ == NULL) {
+		struct seeprom_config *sc;
+
 		targ = ahc_linux_alloc_target(ahc, starget->channel, starget->id);
-		struct seeprom_config *sc = ahc->seep_config;
+		sc = ahc->seep_config;
 		if (targ == NULL)
 			goto out;
 
