From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 2/2] MAINTAINERS: Update cxlflash maintainers
Date: Thu, 21 Jul 2016 15:44:37 -0500
Message-ID: <1469133877-25255-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4439 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbcGUUoz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 16:44:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6LKdDYK140287
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 16:44:54 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24a9p6t9hx-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 16:44:54 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 21 Jul 2016 14:44:53 -0600
In-Reply-To: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Adding myself as a cxlflash maintainer.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2dbc028..e5f5882 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3487,6 +3487,7 @@ F:	Documentation/ABI/testing/sysfs-class-cxl
 CXLFLASH (IBM Coherent Accelerator Processor Interface CAPI Flash) SCSI DRIVER
 M:	Manoj N. Kumar <manoj@linux.vnet.ibm.com>
 M:	Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
+M:	Uma Krishnan <ukrishn@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/cxlflash/
-- 
2.1.0

