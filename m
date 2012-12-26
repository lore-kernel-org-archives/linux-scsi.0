From: vinholikatti@gmail.com
Subject: [PATCH V5 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Thu, 27 Dec 2012 01:45:51 +0530
Message-ID: <50db5b04.644e420a.0ead.ffffbba6@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47606 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2LZUYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Dec 2012 15:24:12 -0500
Received: by mail-pa0-f43.google.com with SMTP id fb10so5067422pad.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Dec 2012 12:24:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, Vinayak Holikatti <vinholikatti@gmail.com>

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch set adds following features
 - Seggregate PCI specific code in ufshcd.c and corrected copyright
 - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
 - Adds Platform glue driver ufshcd-pltfrm.c
 - Update correct transfer size in Command UPIU

Vinayak Holikatti (4):
  [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
  [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
  [SCSI] ufs: Add Platform glue driver for ufshcd
  [SCSI] ufs: Correct the expected data transfer size

 drivers/scsi/ufs/Kconfig         |   87 +++++---
 drivers/scsi/ufs/Makefile        |    2 +
 drivers/scsi/ufs/ufs.h           |   42 ++---
 drivers/scsi/ufs/ufshcd-pci.c    |  211 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  205 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |  416 ++++++++------------------------------
 drivers/scsi/ufs/ufshcd.h        |  200 ++++++++++++++++++
 drivers/scsi/ufs/ufshci.h        |   42 ++---
 8 files changed, 786 insertions(+), 419 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h

-- 
1.7.5.4

