From: akpm@osdl.org
Subject: [patch 1/1] Whitelist-Entry (FORCELUN) for SGS Thomson Microelectronics Cytronix 6in1 card reader in scsi_devinfo.c
Date: Wed, 09 Mar 2005 01:03:32 -0800
Message-ID: <200503090903.j2993vjp022052@shell0.pdx.osdl.net>
Received: from fire.osdl.org ([65.172.181.4]:51845 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261651AbVCIJEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 04:04:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, mail@hboeck.de


From: Hanno Boeck <mail@hboeck.de>

I have a usb-cardreader here that needs some FORCELUN-entries in
scsi_devinfo.c.

lsusb says about the device:

Bus 001 Device 003: ID 0483:1307 SGS Thomson Microelectronics Cytronix 6in1 card reader

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/scsi/scsi_devinfo.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/scsi/scsi_devinfo.c~whitelist-entry-forcelun-for-sgs-thomson-microelectronics-cytronix-6in1-card-reader-in-scsi_devinfoc drivers/scsi/scsi_devinfo.c
--- 25/drivers/scsi/scsi_devinfo.c~whitelist-entry-forcelun-for-sgs-thomson-microelectronics-cytronix-6in1-card-reader-in-scsi_devinfoc	2005-03-09 01:03:19.000000000 -0800
+++ 25-akpm/drivers/scsi/scsi_devinfo.c	2005-03-09 01:03:19.000000000 -0800
@@ -149,6 +149,10 @@ static struct {
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"Generic", "USB Reader-SMC", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"Generic", "USB Reader-CF", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"Generic", "USB Reader-SD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"Generic", "USB Reader-MS", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
_
