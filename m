From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] config: Make need for SCSI_CDROM clearer
Date: Wed, 01 Apr 2009 15:00:18 +0100
Message-ID: <20090401140014.22599.40007.stgit@localhost.localdomain>
References: <20090401135952.22599.26719.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46143 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757810AbZDAN7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 09:59:10 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by www.etchedpixels.co.uk (8.14.3/8.14.3) with ESMTP id n31E0IQN022650
	for <linux-scsi@vger.kernel.org>; Wed, 1 Apr 2009 15:00:18 +0100
In-Reply-To: <20090401135952.22599.26719.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mention ATAPI. We could insert an essay about libata and ide-scsi etc but
the failure case is someone enables it which is just fine so keep it
simple.

(Revised text from suggestion by Matthew Wilcox)

Closes #7736

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/scsi/Kconfig |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e2f44e6..2ee76fb 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -121,10 +121,11 @@ config BLK_DEV_SR
 	tristate "SCSI CDROM support"
 	depends on SCSI
 	---help---
-	  If you want to use a SCSI or FireWire CD-ROM under Linux,
-	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at
-	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
-	  Y or M to "ISO 9660 CD-ROM file system support" later.
+	  If you want to use a CD or DVD drive attached to your computer
+	  by SCSI, FireWire, USB or ATAPI, say Y and read the SCSI-HOWTO
+	  and the CDROM-HOWTO at <http://www.tldp.org/docs.html#howto>.
+
+	  Make sure to say Y or M to "ISO 9660 CD-ROM file system support".
 
 	  To compile this driver as a module, choose M here and read
 	  <file:Documentation/scsi/scsi.txt>.

