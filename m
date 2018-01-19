From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/5] qla2xxx: Fixes for FC-NVMe erorr path.
Date: Fri, 19 Jan 2018 12:29:23 -0800
Message-ID: <20180119202928.13239-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:13824
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756249AbeASU3i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 15:29:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me, james.smart@broadcom.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Christoph,

This series has mostly cleanup and support for devloss timeout in qla2xxx
driver for FC-NVMe protocol. 

Please consider this series for inclusion in 4.16

Thanks,
Himanshu

Darren Trapp (3):
  qla2xxx: Set IIDMA and fcport state before qla_nvme_register_remote()
  qla2xxx: Add changes for devloss timeout in driver
  qla2xxx: Restore ZIO threshold setting

Himanshu Madhani (2):
  qla2xxx: Remove unneeded message and minor cleanup for FC-NVMe
  qla2xxx: Update driver version to 10.00.00.06-k

 drivers/scsi/qla2xxx/qla_def.h     |   1 +
 drivers/scsi/qla2xxx/qla_init.c    |  13 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |   5 +-
 drivers/scsi/qla2xxx/qla_nvme.c    | 158 +++++++++++++++----------------------
 drivers/scsi/qla2xxx/qla_nvme.h    |   6 +-
 drivers/scsi/qla2xxx/qla_target.c  |  13 +--
 drivers/scsi/qla2xxx/qla_target.h  |   2 +-
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 8 files changed, 94 insertions(+), 106 deletions(-)

-- 
2.12.0
