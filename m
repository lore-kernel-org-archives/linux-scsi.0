From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 6/6] cxlflash: Update documentation
Date: Tue,  9 Aug 2016 18:40:13 -0500
Message-ID: <1470786013-9390-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39259 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbcHIXkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 19:40:24 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u79Ncwxh120141
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2016 19:40:24 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9sjgxa-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 19:40:23 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Aug 2016 19:40:22 -0400
In-Reply-To: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Update the block library link in the API documentation.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 Documentation/powerpc/cxlflash.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
index f4c1190..6d9a2ed 100644
--- a/Documentation/powerpc/cxlflash.txt
+++ b/Documentation/powerpc/cxlflash.txt
@@ -121,7 +121,7 @@ Block library API
     below.
 
     The block library can be found on GitHub:
-    http://www.github.com/mikehollinger/ibmcapikv
+    http://github.com/open-power/capiflash
 
 
 CXL Flash Driver IOCTLs
-- 
2.1.0

