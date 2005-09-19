From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] libata: ATA Information VPD page, minor
Date: Mon, 19 Sep 2005 20:29:58 +1000
Message-ID: <432E9326.10206@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030002050908060907020703"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:62387 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932412AbVISK31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 06:29:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

This is a multi-part message in MIME format.
--------------030002050908060907020703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff,
Here is a small followup patch for the ATA Information
VPD page.

Changelog:
  - add entry for ATA information VPD page [0x89] in the
    Supported VPD pages VPD page [0x0]

Doug Gilbert

--------------030002050908060907020703
Content-Type: text/x-patch;
 name="libata2614rc1err_ai2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2614rc1err_ai2.diff"

--- linux/drivers/scsi/libata-scsi.c	2005-09-19 20:14:15.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2614rc1err_ai2	2005-09-19 20:12:34.000000000 +1000
@@ -1065,7 +1065,8 @@
 	const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
-		0x83	/* page 0x83, device ident page */
+		0x83,	/* page 0x83, device ident page */
+		0x89,	/* page 0x89, ATA Information page */
 	};
 	rbuf[3] = sizeof(pages);	/* number of supported EVPD pages */
 

--------------030002050908060907020703--
