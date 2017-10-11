From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: fix doc. typo for I2O
Date: Tue, 10 Oct 2017 17:16:26 -0700
Message-ID: <86c3cc98-3e92-c82f-655e-2fd581ba5539@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33494 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753777AbdJKAQc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 20:16:32 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

From: Randy Dunlap <rdunlap@infradead.org>

Fix typo: I20 should be I2O.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/driver-api/scsi.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-414-rc3.orig/Documentation/driver-api/scsi.rst
+++ lnx-414-rc3/Documentation/driver-api/scsi.rst
@@ -28,7 +28,7 @@ SCSI commands can be transported over ju
 are the default protocol for storage devices attached to USB, SATA, SAS,
 Fibre Channel, FireWire, and ATAPI devices. SCSI packets are also
 commonly exchanged over Infiniband,
-`I20 <http://i2o.shadowconnect.com/faq.php>`__, TCP/IP
+`I2O <http://i2o.shadowconnect.com/faq.php>`__, TCP/IP
 (`iSCSI <https://en.wikipedia.org/wiki/ISCSI>`__), even `Parallel
 ports <http://cyberelk.net/tim/parport/parscsi.html>`__.
 
