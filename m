From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/3] scsi: arcmsr: add driver module parameter -
 msi_enable, msix_enable
Date: Thu, 23 Nov 2017 09:22:03 +0800
Message-ID: <1511400123.9832.14.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Hi all,

The following patches apply to Martin's 4.16/scsi-queue.

Patch 1: Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.

Patch 2: Add module parameter msix_enable to has a chance to disable msix interrupt if it does not work properly.

Patch 3: Update driver version to v1.40.00.03-20171121

Please review. Thanks.
---
