From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v4 0/4]ata: Fixes related to APM X-Gene SATA host controller driver.
Date: Tue, 29 Jul 2014 12:24:48 +0530
Message-ID: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch set contains a couple of fixes related to APM X-Gene SATA
controller driver.

v2 Change:
   1. Drop the Link down retry patch from this patch set.

v4 Change:
   1. Drop the patch to fix the csr-mask in dts for PHY clock
     node of SATA Host Controller 1.
   2. Add the patch to correct the OOB tunning parameters for
     the COMINIT/COMWAKE parameters.
   3. Add the patch to remove the NCQ support from the APM
     X-Gene AHCI SATA Host controller driver.
   4. Add the patch to remove the clock and PHY reference nodes
     from the APM X-Gene Host controller dts node.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (4):
  ata: Fix the watermark threshold for the APM X-Gene SATA host
    controller driver.
  arm64: Remove the clock and PHY reference from the APM X-Gene SoC AHCI
    SATA Host controller dts node.
  ata: Use correct OOB tunning parameters for APM X-Gene SoC AHCI SATA
    Host controller driver.
  ata: Removing NCQ support from the APM X-Gene SoC AHCI SATA Host
    Controller driver.

 arch/arm64/boot/dts/apm-storm.dtsi | 92 --------------------------------------
 drivers/ata/ahci_xgene.c           | 17 ++++---
 2 files changed, 12 insertions(+), 97 deletions(-)

--
1.8.2.1

