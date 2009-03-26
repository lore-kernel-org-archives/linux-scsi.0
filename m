From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] config: Make need for SCSI_CDROM clearer
Date: Thu, 26 Mar 2009 20:54:51 +0000
Message-ID: <20090326205445.5498.17522.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34961 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756781AbZCZUxv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 16:53:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Mention ATAPI. We could insert an essay about libata and ide-scsi etc but
the failure case is someone enables it which is just fine so keep it
simple.

Closes #7736

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 256c7be..6b5091b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -121,7 +121,7 @@ config BLK_DEV_SR
 	tristate "SCSI CDROM support"
 	depends on SCSI
 	---help---
-	  If you want to use a SCSI or FireWire CD-ROM under Linux,
+	  If you want to use a SCSI, FireWire or ATAPI CD-ROM under Linux,
 	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at
 	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
 	  Y or M to "ISO 9660 CD-ROM file system support" later.

