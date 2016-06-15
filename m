From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/3] cxlflash: Shutdown notification and reset patch
Date: Wed, 15 Jun 2016 18:47:40 -0500
Message-ID: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43041 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbcFOXs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 19:48:58 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FNmhHI136777
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:48:58 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23jfmqj5ws-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:48:58 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 19:48:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This patch set contains support to notify CXL Flash devices of an
impending shutdown and a fix to drain operations prior to a reset.

This series is intended for 4.8 and is bisectable.

Manoj N. Kumar (1):
  cxlflash: Fix to drain operations from previous reset

Uma Krishnan (2):
  cxlflash: Add device dependent flags
  cxlflash: Shutdown notify support for CXL Flash cards

 drivers/scsi/cxlflash/main.c    | 98 ++++++++++++++++++++++++++++++++++-------
 drivers/scsi/cxlflash/main.h    |  2 +
 drivers/scsi/cxlflash/sislite.h |  6 +++
 3 files changed, 91 insertions(+), 15 deletions(-)

-- 
2.1.0

