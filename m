From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 0/9] scsi:ufs: query, bkops support and other fixes
Date: Tue, 30 Jul 2013 00:35:56 +0530
Message-ID: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:32957 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3G2TGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 15:06:44 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so1705634pbc.9
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 12:06:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Hi James,

Please apply the following patches to 'misc' branch.

Thanks,
Santosh

Akinobu Mita (3):
  ufshcd-pci: release ioremapped region during removing driver
  ufs: don't disable_irq() if the IRQ can be shared among devices
  ufs: don't stop controller before scsi_remove_host()

Dolev Raviv (1):
  scsi: ufs: Set fDeviceInit flag to initiate device initialization

Sujit Reddy Thumma (3):
  scsi: ufs: Add support for sending NOP OUT UPIU
  scsi: ufs: Add support for host assisted background operations
  scsi: ufs: Add runtime PM support for UFS host controller driver

Wei Yongjun (1):
  ufshcd-pltfrm: remove redundant dev_err call in ufshcd_pltfrm_probe()

Wolfram Sang (1):
  drivers/scsi/ufs: don't check resource with devm_ioremap_resource

 drivers/scsi/ufs/ufs.h           |  155 ++++-
 drivers/scsi/ufs/ufshcd-pci.c    |   99 ++--
 drivers/scsi/ufs/ufshcd-pltfrm.c |   57 +-
 drivers/scsi/ufs/ufshcd.c        | 1170 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h        |   59 +-
 drivers/scsi/ufs/ufshci.h        |    2 +-
 6 files changed, 1376 insertions(+), 166 deletions(-)

-- 
1.8.3.1

