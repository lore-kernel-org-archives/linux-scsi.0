From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] documentation: add scsi_common.c to SCSI driver-api
Date: Sun, 10 Dec 2017 10:11:44 -0800
Message-ID: <a185cba0-e5f8-b347-54c7-10cbf32402d8@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48459 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbdLJSL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Dec 2017 13:11:56 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Randy Dunlap <rdunlap@infradead.org>

Add exported functions from scsi_common.c to the SCSI driver API
documentation.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
---
 Documentation/driver-api/scsi.rst |    8 ++++++++
 1 file changed, 8 insertions(+)

--- lnx-415-rc2.orig/Documentation/driver-api/scsi.rst
+++ lnx-415-rc2/Documentation/driver-api/scsi.rst
@@ -224,6 +224,14 @@ mid to lowlevel SCSI driver interface
 .. kernel-doc:: drivers/scsi/hosts.c
    :export:
 
+drivers/scsi/scsi_common.c
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+general support functions
+
+.. kernel-doc:: drivers/scsi/scsi_common.c
+   :export:
+
 Transport classes
 -----------------
 
