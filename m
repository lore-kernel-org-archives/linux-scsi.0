From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] mark eata_pio broken
Date: Thu, 10 Feb 2005 14:17:45 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BC57A66@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:13698 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261348AbVBJTRr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 14:17:47 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

I approve, even though I have one of these ISA cards still in-service
;->

I understand that 'BROKEN' means eventually the driver gets removed from
the source tree; as long as it would still be available in old archives
...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Thursday, February 10, 2005 1:17 PM
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] mark eata_pio broken

it oopses when trying to use it with my SmartRaid IV card, it's a mess
and the only hardware supported by it but not the eata driver are two
10-year old ISA boards.


--- 1.95/drivers/scsi/Kconfig	2005-01-28 18:14:29 +01:00
+++ edited/drivers/scsi/Kconfig	2005-02-10 14:59:56 +01:00
@@ -611,7 +611,7 @@
 
 config SCSI_EATA_PIO
 	tristate "EATA-PIO (old DPT PM2001, PM2012A) support"
-	depends on (ISA || EISA || PCI) && SCSI
+	depends on (ISA || EISA || PCI) && SCSI && BROKEN
 	---help---
 	  This driver supports all EATA-PIO protocol compliant SCSI Host
 	  Adapters like the DPT PM2001 and the PM2012A.  EATA-DMA
compliant
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
