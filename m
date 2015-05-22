From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2] IBM CXL Flash Adapter
Date: Fri, 22 May 2015 17:14:20 -0500
Message-ID: <1432332860-11160-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:49729 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbbEVWPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 18:15:33 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 22 May 2015 16:15:33 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id EA3F61FF0023
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 16:06:40 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4MMFIEH49021022
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 15:15:18 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4MMFSx1008657
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 16:15:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

v2 Changes:

- Update to candidate upstream CXL APIs
- Add several clarification comments
- Renamed some structures for clarity
- Removed the 'cxlflash' prefix from internal functions
- Address endianness concerns/issues
- Remove unused code
- Revert to using pr_*/dev_* print services
- Remove unneeded locking and barrier instructions

This patch adds support for the IBM CXL flash (cxlflash) adapter. The device
is presented to the system as a SCSI adapter and may be accessed and used via
the normal filesystem paths.

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
 drivers/scsi/cxlflash/common.h  |  180 ++++
 drivers/scsi/cxlflash/main.c    | 2242 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h    |  111 ++
 drivers/scsi/cxlflash/sislite.h |  465 ++++++++
 8 files changed, 3013 insertions(+)
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100755 drivers/scsi/cxlflash/sislite.h

-- 
2.1.0

