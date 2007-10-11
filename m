From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 1/3] Re: sil3114 data corruption
Date: Thu, 11 Oct 2007 14:15:34 +0200
Message-ID: <200710111415.35203.bs@q-leap.de>
References: <200710081709.18253.bs@q-leap.de> <200710101112.20448.bs@q-leap.de> <200710111409.56210.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:49690 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXJKMPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 08:15:37 -0400
In-Reply-To: <200710111409.56210.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bernd Schubert <bs@q-leap.de>

This will add the Seagate ST3250820AS to the mod15 blacklist.

I think this is rather trivial and should go into any any release as soon as 
possible, since there will be data corruption without it for this disk.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

Index: linux-2.6.23-rc9/drivers/ata/sata_sil.c
===================================================================
--- linux-2.6.23-rc9.orig/drivers/ata/sata_sil.c	2007-10-11 10:44:57.000000000 
+0200
+++ linux-2.6.23-rc9/drivers/ata/sata_sil.c	2007-10-11 10:45:02.000000000 
+0200
@@ -151,6 +151,7 @@ static const struct sil_drivelist {
 	{ "ST380011ASL",	SIL_QUIRK_MOD15WRITE },
 	{ "ST3120022ASL",	SIL_QUIRK_MOD15WRITE },
 	{ "ST3160021ASL",	SIL_QUIRK_MOD15WRITE },
+	{ "ST3250820AS",	SIL_QUIRK_MOD15WRITE },
 	{ "Maxtor 4D060H3",	SIL_QUIRK_UDMA5MAX },
 	{ }
 };



-- 
Bernd Schubert
Q-Leap Networks GmbH
