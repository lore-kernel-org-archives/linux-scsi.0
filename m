From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/3] cxlflash: Miscellaneous fixes
Date: Fri, 25 Aug 2017 17:17:20 -0500
Message-ID: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47855 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933269AbdHYWRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 18:17:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7PMDiZY143758
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:17:32 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cjukvabup-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:17:32 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 25 Aug 2017 18:17:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This patch series contains miscellaneous fixes. The first two address
issues that were identified by smatch and the last patch fixes a regression
introduced by Commit 565180723294 ("scsi: cxlflash: SISlite updates to
support 4 ports").

This series is intended for 4.14 and is bisectable.

Matthew R. Ochs (2):
  cxlflash: Remove unnecessary existence check
  cxlflash: Avoid double mutex unlock

Uma Krishnan (1):
  cxlflash: Fix vlun resize failure in the shrink path

 drivers/scsi/cxlflash/main.c      |  3 +--
 drivers/scsi/cxlflash/superpipe.c | 13 ++++++++++---
 drivers/scsi/cxlflash/vlun.c      |  6 +-----
 3 files changed, 12 insertions(+), 10 deletions(-)

-- 
2.1.0
