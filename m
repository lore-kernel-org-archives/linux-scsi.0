From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/6] cxlflash: Miscellaneous patches
Date: Wed,  3 Jan 2018 16:53:22 -0600
Message-ID: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751262AbeACWxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 17:53:37 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id w03MnFO9009905
        for <linux-scsi@vger.kernel.org>; Wed, 3 Jan 2018 17:53:37 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2f982y0hqy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jan 2018 17:53:36 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 3 Jan 2018 17:53:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This patch series contains miscellaneous fixes. The first patch fixes a
bug while the rest improve the code structure and prepare the code for
future enhancements.

This series is intended for 4.16 and is bisectable.

Matthew R. Ochs (3):
  cxlflash: Explicitly cache number of interrupts per context
  cxlflash: Remove embedded CXL work structures
  cxlflash: Staging to support future accelerators

Uma Krishnan (3):
  cxlflash: Reset command ioasc
  cxlflash: Update cxl-specific arguments to generic cookie
  cxlflash: Adapter context init can return error

 drivers/scsi/cxlflash/Makefile    |   2 +-
 drivers/scsi/cxlflash/backend.h   |  41 ++++++++++
 drivers/scsi/cxlflash/common.h    |   8 +-
 drivers/scsi/cxlflash/cxl_hw.c    | 168 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.c      | 100 +++++++++--------------
 drivers/scsi/cxlflash/superpipe.c |  64 +++++++--------
 drivers/scsi/cxlflash/superpipe.h |   4 +-
 7 files changed, 288 insertions(+), 99 deletions(-)
 create mode 100644 drivers/scsi/cxlflash/backend.h
 create mode 100644 drivers/scsi/cxlflash/cxl_hw.c

-- 
2.1.0
