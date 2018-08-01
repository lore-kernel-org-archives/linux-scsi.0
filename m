From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH 0/4] use dma_zalloc_coherent and vzalloc to replace open code
Date: Wed, 1 Aug 2018 21:26:12 +0800
Message-ID: <1533129976-51930-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: john.garry@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: andy.shevchenko@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


zhong jiang (4):
  driver/scsi/fnic/fnic_trace: Use vzalloc to zero instead of
    vmalloc+memset
  drivers/scsi/dpt_i2o: Use dma_zalloc_coherent to repalce
    dma_alloc_coherent+memset
  drivers/scsi/snic/snic_trc: Use vzalloc instead of vmalloc+memset
  drivers/scsi/mvsas/mv_init: Use dma_zalloc_coherent to replace
    dma_alloc_coherent+memset

 drivers/scsi/dpt_i2o.c         | 12 ++++--------
 drivers/scsi/fnic/fnic_trace.c |  3 +--
 drivers/scsi/mvsas/mv_init.c   | 12 ++++--------
 drivers/scsi/snic/snic_trc.c   |  3 +--
 4 files changed, 10 insertions(+), 20 deletions(-)

-- 
1.7.12.4
