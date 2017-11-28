From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 0/3] scsi: arcmsr: add driver module parameter -
 msi_enable, msix_enable
Date: Tue, 28 Nov 2017 09:17:19 +0800
Message-ID: <1511831839.4399.12.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

The following patches apply to james' kernel/git/jejb/scsi.git/tree/?h=misc and
                             martin's kernel/git/mkp/scsi.git/tree/?h=4.16/scsi-queue

Patch 1: Add module parameter msi_enable to has a chance to disable msi interrupt if controller has msi INT compatible issue.

Patch 2: Add module parameter msix_enable to has a chance to disable msix interrupt if controller has msix INT compatible issue.

Patch 3: Update driver version to v1.40.00.03-20171124
---
