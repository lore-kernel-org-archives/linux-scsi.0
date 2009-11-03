From: Roel Kluin <roel.kluin@gmail.com>
Subject: aic7xxx: Missing parentheses in ahc_init()?
Date: Tue, 03 Nov 2009 23:38:55 +0100
Message-ID: <4AF0B0FF.6000706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42840 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZKCW1e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 17:27:34 -0500
Received: by ewy3 with SMTP id 3so2505435ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2009 14:27:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

This looks odd, are there maybe parentheses missing here?

Thanks, Roel

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 8dfb59d..e6aad3e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -5534,8 +5534,8 @@ ahc_init(struct ahc_softc *ahc)
 					 * so the format is different.
 					 */
 					scsirate = (scsirate & SXFR) >> 4
-						 | (ultraenb & mask)
-						  ? 0x08 : 0x0
+						 | ((ultraenb & mask)
+						  ? 0x08 : 0x0)
 						 | (scsirate & WIDEXFER);
 					offset = MAX_OFFSET_ULTRA2;
 				} else
