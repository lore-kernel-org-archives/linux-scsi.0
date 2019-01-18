From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 0/3] scsi: arcmsr: Fix suspend/resume of
 ACB_ADAPTER_TYPE_B part 2
Date: Fri, 18 Jan 2019 10:47:25 +0800
Message-ID: <1547779645.4532.9.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

This patch series are against to mkp's 5.1/scsi-queue.

1. Due to dma_zalloc_coherent will be phase out, so use dma_alloc_coherent instead.
2. For ACB_ADAPTER_TYPE_B controller, the read/write after hibernate and resume may
got 'isr get an illegal ccb command' in log/messages sometimes. This patch fix it.
3. Update driver version to v1.40.00.10-20190116
---
