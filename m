From: Ching Huang <ching2048@areca.com.tw>
Subject: Fix suspend/resume of ACB_ADAPTER_TYPE_B part 2
Date: Thu, 17 Jan 2019 11:31:29 +0800
Message-ID: <1547695889.4339.10.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

This patch series are against to mkp's 5.1/scsi-queue.

1. Due to dma_zalloc_coherent will be phase out, so use dma_alloc_coherent to replace it.
2. Fix suspend/resume of ACB_ADAPTER_TYPE_B part 2.
3. Update driver version to v1.40.00.10-20190116
---
