From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 0/1] IBM CXL Flash Adapter
Date: Fri, 15 May 2015 16:10:02 -0500
Message-ID: <1431724202-2860-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:36519 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422755AbbEOVLG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 17:11:06 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 15 May 2015 17:11:05 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id A1594C90041
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 17:02:09 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4FLB1c446006328
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 21:11:01 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4FLB0i2031350
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 17:11:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

This patch set adds support for the IBM CXL flash (cxlflash) adapter. The
device is presented to the system as a SCSI adapter and may be accessed
and used via the normal filesystem paths

Note that the patch is dependent on support that has not yet been merged
in with the mainline (submission expected shortly).

In the interim, this code may be found on Github:

   https://github.com/mikey/linux/tree/cxl/kernelapi

Matthew R. Ochs (1):
  cxlflash: Base support for IBM CXL Flash Adapter

 drivers/scsi/Kconfig            |    1 +
 drivers/scsi/Makefile           |    1 +
 drivers/scsi/cxlflash/Kconfig   |   11 +
 drivers/scsi/cxlflash/Makefile  |    2 +
 drivers/scsi/cxlflash/common.h  |  250 +++++
 drivers/scsi/cxlflash/main.c    | 2224 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h    |  111 ++
 drivers/scsi/cxlflash/sislite.h |  413 ++++++++
 8 files changed, 3013 insertions(+)
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100755 drivers/scsi/cxlflash/sislite.h

-- 
2.1.0

