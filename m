From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v6 0/2]  ata: Fix the dma state machine lockup for APM X-Gene SoC
Date: Mon,  7 Jul 2014 22:33:03 +0530
Message-ID: <1404752585-915-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch addresses the dma state machine lockup for APM X-Gene SoC.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (2):
  libahci: Export some of the libahci functions.
  ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
    command.

 drivers/ata/ahci.h       |  2 ++
 drivers/ata/ahci_xgene.c | 60 +++++++++++++++++++++++++++++++++++++-----------
 drivers/ata/libahci.c    |  7 +++---
 3 files changed, 53 insertions(+), 16 deletions(-)

--
1.8.2.1

