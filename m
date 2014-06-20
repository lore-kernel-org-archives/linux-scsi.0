From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v0 0/3]ata: Fixes related to APM X-Gene SATA host controller driver.
Date: Fri, 20 Jun 2014 14:02:24 +0530
Message-ID: <1403253147-14341-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch set contains a couple of fixes related to APM X-Gene SATA
controller driver.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
Suman Tripathi (3):
  ata: Fix the watermark threshold for the APM X-Gene SATA host
    controller driver.
  ata: Fix the link down in first attempt for the APM X-Gene SoC AHCI
    SATA host controller driver.
  aram64: Fix the APM X-Gene SoC SATA PHY clock DTS node csr-mask of the
    SATA Host Controller 1.

 arch/arm64/boot/dts/apm-storm.dtsi |  2 +-
 drivers/ata/ahci_xgene.c           | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

--
1.8.2.1

