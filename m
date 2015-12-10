From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/6] cxlflash: Miscellaneous fixes and updates
Date: Thu, 10 Dec 2015 16:51:07 -0600
Message-ID: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:41372 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbLJWwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 17:52:09 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 10 Dec 2015 17:52:08 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 9E50EC90052
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 17:40:15 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBAMq6ZD29622472
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 22:52:06 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBAMn846020379
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 17:49:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

This patch set contains miscellaneous fixes and adds support for
a future IBM CXL adapter. This series is intended for 4.5 and is
bisectable.

Manoj Kumar (4):
  cxlflash: Fix to escalate LINK_RESET also on port 1
  cxlflash: Fix to resolve cmd leak after host reset
  cxlflash: Resolve oops in wait_port_offline
  cxlflash: Enable device id for future IBM CXL adapter

Matthew R. Ochs (1):
  cxlflash: Fix to avoid virtual LUN failover failure

Uma Krishnan (1):
  cxlflash: Updated date of the driver

 drivers/scsi/cxlflash/common.h     |  2 ++
 drivers/scsi/cxlflash/main.c       | 51 +++++++++++++++++++++++++++++++++-----
 drivers/scsi/cxlflash/main.h       |  6 ++---
 drivers/scsi/cxlflash/vlun.c       |  2 ++
 include/uapi/scsi/cxlflash_ioctl.h | 10 ++++++++
 5 files changed, 62 insertions(+), 9 deletions(-)

-- 
2.1.0

