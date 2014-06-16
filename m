From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v2 0/2]ata: Fix the dma state machine lockup for APM X-Gene SoC
Date: Mon, 16 Jun 2014 15:05:34 +0530
Message-ID: <1402911336-31788-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Suman Tripathi (2):
  libahci: Implement the function ahci_restart_engine to restart the
    port dma engine.
  ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
    command.

 drivers/ata/ahci.h       |  4 ++++
 drivers/ata/ahci_xgene.c | 17 +++--------------
 drivers/ata/libahci.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 14 deletions(-)

--
1.8.2.1

