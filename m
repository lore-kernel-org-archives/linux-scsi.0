From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v5 0/3] ata: ahci_xgene: Add support for 2nd HW version of APM X-Gene SoC AHCI SATA Host controller driver.
Date: Wed,  6 May 2015 00:51:09 +0530
Message-ID: <1430853672-6227-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

V2 change:
 * Drop the MIDR based implementation.

V3 change:
 * Implement the support for HOST_IRQ_STAT as edge trigger latch.

V4 change:
 * Implement seperate irq handler for level and edge trigger latch.

V5 change:
 * Refactoring the ahci_single_irq_intr.
 * Split refactoring of level trigger and edge trigger into 2 patches.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---


Suman Tripathi (3):
  libahci: Refactoring of ahci_single_irq_intr function.
  libahci: Add support to handle HOST_IRQ_STAT as edge      trigger
    latch.
  ata: ahci_xgene: Add AHCI Support for 2nd HW version of      APM
    X-Gene SoC AHCI SATA Host controller.

 drivers/ata/ahci.h       |  2 ++
 drivers/ata/ahci_xgene.c | 90 ++++++++++++++++++++++++++++++++++++++----------
 drivers/ata/libahci.c    | 89 ++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 143 insertions(+), 38 deletions(-)

--
1.8.2.1

