From: Olaf Hering <olh@suse.de>
Subject: Re: [PACH] mesh is ppc32-only
Date: Mon, 6 Sep 2004 15:32:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906133232.GA9133@suse.de>
References: <20040825164043.GB12679@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50592 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267393AbUIFNce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 09:32:34 -0400
Content-Disposition: inline
In-Reply-To: <20040825164043.GB12679@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

 On Wed, Aug 25, Christoph Hellwig wrote:

> mesh is only present on older 32bit pmac boards and doesn't compile
> on ppc64.

This applies also to the other pmac-only scsi driver:


diff -purN linux-2.6.9-rc1-bk13.orig/drivers/scsi/Kconfig linux-2.6.9-r=
c1-bk13/drivers/scsi/Kconfig
--- linux-2.6.9-rc1-bk13.orig/drivers/scsi/Kconfig	2004-09-06 15:23:36.=
000000000 +0200
+++ linux-2.6.9-rc1-bk13/drivers/scsi/Kconfig	2004-09-06 15:26:43.14805=
2174 +0200
@@ -1494,7 +1494,7 @@ config SCSI_MESH_RESET_DELAY_MS
=20
 config SCSI_MAC53C94
 	tristate "53C94 (Power Mac external SCSI) support"
-	depends on PPC_PMAC && SCSI
+	depends on PPC32 && PPC_PMAC && SCSI
 	help
 	  On Power Macintoshes (and clones) with two SCSI buses, the external
 	  SCSI bus is usually controlled by a 53C94 SCSI bus adaptor. Older

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
