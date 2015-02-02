From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v3] Fix the dma state machine lockup for the ATA_CMD_SMART PIO mode command.
Date: Mon,  2 Feb 2015 23:37:18 +0530
Message-ID: <1422900439-5541-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

v1 changes:
 * Update the commit id as per Tejun's comments.
 * Add a bit explanation.

v2 changes:
 * Update the comments from sergei.

v3 changes:
 * More changes in comments.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (1):
  ahci_xgene: Fix the dma state machine lockup for the ATA_CMD_SMART PIO
    mode command.

 drivers/ata/ahci_xgene.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--
1.8.2.1

