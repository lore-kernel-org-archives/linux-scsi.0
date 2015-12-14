From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 0/6] cxlflash: Miscellaneous fixes and updates
Date: Mon, 14 Dec 2015 14:51:33 -0600
Message-ID: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:46700 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbbLNUwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 15:52:30 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 15:52:29 -0500
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 514A6C9003E
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 15:40:36 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEKqRh027787450
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 20:52:27 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEKqP7M005500
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 15:52:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>

This patch set contains miscellaneous fixes and adds support for
a future IBM CXL adapter. This series is intended for 4.5 and is
bisectable. Please reference the changelog below for details on
what has been altered from previous versions of this patch set.

v2 Changes:
- Incorporate comments from Daniel Axtens
- Incorporate comments from Andrew Donnellan
- Removed driver date and simplified driver load print
- Clarified driver behavior for the future adapter

Manoj Kumar (4):
  cxlflash: Fix to escalate LINK_RESET also on port 1
  cxlflash: Fix to resolve cmd leak after host reset
  cxlflash: Resolve oops in wait_port_offline
  cxlflash: Enable device id for future IBM CXL adapter

Matthew R. Ochs (1):
  cxlflash: Fix to avoid virtual LUN failover failure

Uma Krishnan (1):
  cxlflash: Removed driver date print

 drivers/scsi/cxlflash/common.h     |  2 ++
 drivers/scsi/cxlflash/main.c       | 54 ++++++++++++++++++++++++++++++++------
 drivers/scsi/cxlflash/main.h       |  5 ++--
 drivers/scsi/cxlflash/vlun.c       |  2 ++
 include/uapi/scsi/cxlflash_ioctl.h | 10 +++++++
 5 files changed, 62 insertions(+), 11 deletions(-)

-- 
2.1.0

