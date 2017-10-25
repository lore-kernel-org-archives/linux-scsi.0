From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/3] cxlflash: Miscellaneous fixes
Date: Wed, 25 Oct 2017 16:35:02 -0500
Message-ID: <1508967302-54403-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751407AbdJYVfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 17:35:32 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9PLZOTc146093
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:35:32 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2du0k2n65x-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:35:32 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 25 Oct 2017 15:35:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This patch series contains miscellaneous fixes. All three patches resolve
minor issues.

This series is intended for 4.15 and is bisectable.

Matthew R. Ochs (3):
  cxlflash: Use derived maximum write same length
  cxlflash: Allow cards without WWPN VPD to configure
  cxlflash: Derive pid through accessors

 drivers/scsi/cxlflash/main.c      | 24 +++++++++++++++++-------
 drivers/scsi/cxlflash/main.h      |  3 ++-
 drivers/scsi/cxlflash/sislite.h   |  3 ---
 drivers/scsi/cxlflash/superpipe.c |  6 +++---
 drivers/scsi/cxlflash/vlun.c      |  6 ++++--
 5 files changed, 26 insertions(+), 16 deletions(-)

-- 
2.1.0
