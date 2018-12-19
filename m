From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/12] scsi: arcmsr: update for ccb structure address can
 above 4GB
Date: Wed, 19 Dec 2018 16:17:41 +0800
Message-ID: <1545207461.4457.10.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

This patch series are against to mkp's 4.21/scsi-queue.

1. Rename acb structure member roundup_ccbsize to ioqueue_size
2. Rename arcmsr_free_mu to arcmsr_free_io_queue
3. Merge arcmsr_alloc_io_queue to arcmsr_alloc_ccb_pool
4. Update arcmsr_alloc_ccb_pool for ccb buffer address above 4GB
5. Update codes for ACB_ADAPTER_TYPE_A in case of ccb address above 4GB
6. Update codes for ACB_ADAPTER_TYPE_B in case of ccb address above 4GB
7. Update codes for ACB_ADAPTER_TYPE_C in case of ccb address above 4GB
8. Update codes for ACB_ADAPTER_TYPE_D in case of ccb address above 4GB
9. Add an option of set dma_mask_64 for ACB_ADAPTER_TYPE_A
10.Separate 'set dma mask' as a function
11.Fix suspend/resume of ACB_ADAPTER_TYPE_B
12.Update driver version to v1.40.00.10-20181217
---
