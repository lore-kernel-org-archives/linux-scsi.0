From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v3 0/2] ahci_xgene: Bug fixes in APM X-Gene Soc AHCI SATA controller driver.
Date: Mon, 29 Dec 2014 08:52:45 +0530
Message-ID: <1419823367-11279-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

These patches address the following two issues :

1. Endianess issue with xgene_read_id function.
2. ATAPI device enumeration failure with ATA_CMD_PACKET PIO mode command.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (2):
  ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI SATA
    controller driver.
  ahci_xgene: Fix the DMA state machine lockup for the ATA_CMD_PACKET
    PIO mode command.

 drivers/ata/ahci_xgene.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--
1.8.2.1

