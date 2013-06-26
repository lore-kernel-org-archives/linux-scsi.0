From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 00/10] scsi: ufs: link start-up rework and other fixes
Date: Wed, 26 Jun 2013 22:33:56 +0530
Message-ID: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59538 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3FZREh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:04:37 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so1573401pdi.27
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:04:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 00james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Hi James,

Please merge the following patches to 'misc' branch.

Thanks,
Santosh

Akinobu Mita (4):
  ufshcd-pltfrm: add missing empty slot in ufs_of_match[]
  ufs: fix register address in UIC error interrupt handling
  ufshcd-pltfrm: remove unnecessary dma_set_coherent_mask() call
  ufs: fix DMA mask setting

Seungwon Jeon (5):
  scsi: ufs: wrap the i/o access operations
  scsi: ufs: amend interrupt configuration
  scsi: ufs: remove version check before IS reg clear
  scsi: ufs: rework link start-up process
  scsi: ufs: use devres functions for ufshcd

Sujit Reddy Thumma (1):
  scsi: ufs: Fix the response UPIU length setting

 drivers/scsi/ufs/ufshcd-pci.c    |  27 ---
 drivers/scsi/ufs/ufshcd-pltfrm.c |  75 ++----
 drivers/scsi/ufs/ufshcd.c        | 484 +++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h        |  21 +-
 drivers/scsi/ufs/ufshci.h        |   5 +-
 5 files changed, 351 insertions(+), 261 deletions(-)

-- 
1.8.3.1

