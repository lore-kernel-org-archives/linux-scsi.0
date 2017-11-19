From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: fix another I2O typo
Date: Sat, 18 Nov 2017 17:46:59 -0800
Message-ID: <8885e6a1-5a41-2a9c-aaf3-d0ba061b4775@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53600 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdKSBrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Nov 2017 20:47:02 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

From: Randy Dunlap <rdunlap@infradead.org>

Correct another typo I20 to I2O.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/driver-api/scsi.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-414.orig/Documentation/driver-api/scsi.rst
+++ lnx-414/Documentation/driver-api/scsi.rst
@@ -332,5 +332,5 @@ todo
 ~~~~
 
 Parallel (fast/wide/ultra) SCSI, USB, SATA, SAS, Fibre Channel,
-FireWire, ATAPI devices, Infiniband, I20, iSCSI, Parallel ports,
+FireWire, ATAPI devices, Infiniband, I2O, iSCSI, Parallel ports,
 netlink...
