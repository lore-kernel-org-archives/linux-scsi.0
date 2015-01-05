From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH 0/2] Add the PMP support for APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Mon,  5 Jan 2015 17:16:02 +0530
Message-ID: <1420458362-23396-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch set implements the PMP support for APM X-Gene SoC AHCI SATA Host Controller driver.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (2):
  ahci_xgene: Fix the xgene_ahci_restart_engine function to support Port
    Multiplier for APM X-Gene SoC AHCI SATA host controller driver.
  ahci_xgene: Implement the workaround to support PMP enumeration and
    discovery for APM X-Gene SoC AHCI SATA Host Controller driver.

 drivers/ata/ahci_xgene.c | 180 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 178 insertions(+), 2 deletions(-)

--
1.8.2.1

