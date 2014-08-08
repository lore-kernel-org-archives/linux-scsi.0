From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v6 0/2] ahci_xgene: Fixes related to APM X-Gene SATA host controller driver.
Date: Fri,  8 Aug 2014 21:44:24 +0530
Message-ID: <1407514466-25312-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:46533 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756020AbaHHQPh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 12:15:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

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

v5 Change :
   1. All the patches are based on 3.16.0-rc6/for-3.17 kernel.
   2. Drop the patch to remove the clock and PHY reference nodes
     from the APM X-Gene Host controller dts node as it breaks
     with old firmware.
   3. Add the patch to skip phy and clock initialisation if
     already done in the firmware.
   4. Add the patch to fix the csr-mask in dts for PHY clock
     node of SATA Host Controller 1.
   5. Add the patch to remove the NCQ support from the APM
     X-Gene AHCI SATA Host controller driver based on 3.16.0-rc6/
     for-3.17 kernel.
   6. Drop the patch to correct the OOB tunning parameters for
     the COMINIT/COMWAKE parameters as it is already applied to
     3.16/for-3.17 branch by the maintainer.
   7. Drop the patch to fix the watermark threshold as it is
     already applied to 3.16/for-3.17 branch by the maintainer.

v6 change :
   1. Drop the patch to skip phy and clock initialisation if
     already done in the firmware.
   2. Drop the patch to fix the csr-mask in dts for PHY clock
     node of SATA Host Controller 1.
   3. Add the remove the clock and PHY node patch as it
     fixes the dropped patches together. This patch works with
     old and new firmware as well.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (2):
  ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI SATA
    Host Controller driver.
  arm64: Remove the clock and PHY reference from the APM X-Gene SoC AHCI
    SATA Host controller dts node.

 .../devicetree/bindings/ata/apm-xgene.txt          | 10 +--
 arch/arm64/boot/dts/apm-storm.dtsi                 | 93 ----------------------
 drivers/ata/ahci_xgene.c                           |  4 +-
 3 files changed, 7 insertions(+), 100 deletions(-)

--
1.8.2.1

