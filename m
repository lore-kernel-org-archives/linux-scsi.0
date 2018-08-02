From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH v2 0/4] Use dma_zalloc_coherent and kvcalloc to replace open code
Date: Thu, 2 Aug 2018 19:28:30 +0800
Message-ID: <1533209314-1074-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: andy.shevchenko@gmail.com, joe@perches.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 
v1->v2: 

According to Andy and Joe suggestions. 
[patch 1/4] get rid of unnessary parens and use kvcalloc and kvfree to
replace the vmalloc and vfree.
[patch 2/4] modify the changelog as Andy's suggestion.
[patch 3/4] replace vmalloc and vfree by using kvcalloc adn kvfree.
[patch 4/4] do nothing. just add Andy's review-by.


zhong jiang (4):
  driver/scsi/fnic/fnic_trace: Use kvcalloc instead of vmalloc+memset
  drivers/scsi/dpt_i2o: Use dma_zalloc_coherent to repalce
    dma_alloc_coherent+memset
  drivers/scsi/snic/snic_trc: Use kvcalloc instead of vmalloc+memset
  drivers/scsi/mvsas/mv_init: Use dma_zalloc_coherent to replace
    dma_alloc_coherent+memset

 drivers/scsi/dpt_i2o.c         | 12 ++++--------
 drivers/scsi/fnic/fnic_trace.c |  7 +++----
 drivers/scsi/mvsas/mv_init.c   | 12 ++++--------
 drivers/scsi/snic/snic_trc.c   |  7 +++----
 4 files changed, 14 insertions(+), 24 deletions(-)

-- 
1.7.12.4
