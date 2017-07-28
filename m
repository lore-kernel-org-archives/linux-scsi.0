From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 04/22] zfcp: convert bool-definitions to use 'true' instead of '1'
Date: Fri, 28 Jul 2017 12:30:50 +0200
Message-ID: <d3aedd844d21b31a6b2bc8c17fa6397c3aa177e7.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41391 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751891AbdG1KbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:14 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SAScnt062550
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:14 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2c01jmwh85-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:12 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAV9oE21561434
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADFE84C0B0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:39 +0100 (BST)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E3A74C0AC
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:39 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:39 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

Better form and cleans remaining warnings.

Found with scripts/coccinelle/misc/boolinit.cocci.

Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_qdio.c | 2 +-
 drivers/s390/scsi/zfcp_scsi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index dbf2b54703f7..9e358fc04b78 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -14,7 +14,7 @@
 #include "zfcp_ext.h"
 #include "zfcp_qdio.h"
 
-static bool enable_multibuffer = 1;
+static bool enable_multibuffer = true;
 module_param_named(datarouter, enable_multibuffer, bool, 0400);
 MODULE_PARM_DESC(datarouter, "Enable hardware data router support (default on)");
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 0678cf714c0e..d99da4e1e27a 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -28,7 +28,7 @@ static bool enable_dif;
 module_param_named(dif, enable_dif, bool, 0400);
 MODULE_PARM_DESC(dif, "Enable DIF/DIX data integrity support");
 
-static bool allow_lun_scan = 1;
+static bool allow_lun_scan = true;
 module_param(allow_lun_scan, bool, 0600);
 MODULE_PARM_DESC(allow_lun_scan, "For NPIV, scan and attach all storage LUNs");
 
-- 
2.11.2
