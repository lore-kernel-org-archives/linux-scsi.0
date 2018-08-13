From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH 0/2] scsi: Use PTR_ERR_OR_ZERO to replace the open code
Date: Mon, 13 Aug 2018 19:10:38 +0800
Message-ID: <1534158640-24353-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The issue is detected with the help of Coccinelle.

zhong jiang (2):
  scsi:ufs: Use PTR_ERR_OR_ZERO to replace the open code
  scsi:qla2xxx: Use PTR_ERR_OR_ZERO to replace the open code

 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 6 ++----
 drivers/scsi/ufs/ufs-hisi.c        | 4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

-- 
1.7.12.4
