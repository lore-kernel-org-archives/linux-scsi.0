From: "John W. Linville" <linville@tuxdriver.com>
Subject: [patch] 2.6 -- add IOI Media Bay to SCSI quirk list
Date: Thu, 12 Aug 2004 17:37:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408122137.i7CLbGU13688@ra.tuxdriver.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from apollo.tuxdriver.com ([24.172.12.4]:53265 "EHLO
	ra.tuxdriver.com") by vger.kernel.org with ESMTP id S268844AbUHLWko
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 18:40:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Patch to add IOI Media Bay 4-in-1 media reader to the SCSI quirk list...

"It works for me!"  Pretty simple patch, really...

John

diff -urNp linux-2.6.5-1.358/drivers/scsi/scsi_devinfo.c linux/drivers/scsi/scsi_devinfo.c
--- linux-2.6.5-1.358/drivers/scsi/scsi_devinfo.c	2004-05-08 08:56:41.000000000 -0400
+++ linux/drivers/scsi/scsi_devinfo.c	2004-08-11 06:08:00.000000000 -0400
@@ -155,6 +155,7 @@ static struct {
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"IOI", "Media Bay", NULL, BLIST_FORCELUN},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
