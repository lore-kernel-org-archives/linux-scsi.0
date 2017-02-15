From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/3] qla2xxx: Bug fixes and cleanup for the driver.
Date: Wed, 15 Feb 2017 15:37:18 -0800
Message-ID: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0081.outbound.protection.outlook.com ([104.47.33.81]:2396
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753837AbdBOXiU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 18:38:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin,

This series contains small cleanup + fix for regression that was introduced by
pci_alloc_irq_vectors_affinity() call in driver. 

Please apply this series to 4.10/scsi-fixes at your earliest convenience.

Thanks,
Himanshu

Michael Hernandez (3):
  qla2xxx: Cleaned up queue configuration code.
  qla2xxx: Fix response queue count for Target mode.
  qla2xxx: Fix Regression introduced by pci_alloc_irq_vectors_affinity
    call.

 drivers/scsi/qla2xxx/qla_isr.c |  7 +++++--
 drivers/scsi/qla2xxx/qla_os.c  | 16 ++++++----------
 2 files changed, 11 insertions(+), 12 deletions(-)

-- 
1.8.3.1
