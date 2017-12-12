From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/4] scsi: arcmsr: simplify hba_get_config routine
Date: Tue, 12 Dec 2017 18:39:53 +0800
Message-ID: <1513075193.5249.14.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

These patches are apply to Martin's 4.16/scsi-queue.

patch 1: simplify arcmsr_hbaC_get_config function.

patch 2: wait iop firmware ready before issue get_config command to iop.

patch 3: simplify arcmsr_hbaE_get_config function.

patch 4: simplify all arcmsr_hbaX_get_config routine by call a new get_adapter_config function
---
