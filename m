From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v5 0/3] ahci_xgene: Fixes related to APM X-Gene SATA host controller driver.
Date: Fri,  1 Aug 2014 23:07:15 +0530
Message-ID: <1406914638-24721-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
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

Signed-off-by: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---

Suman Tripathi (3):
  ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI SATA
    Host Controller driver.
  arm64: Fix the csr-mask for APM X-Gene SoC AHCI SATA PHY clock DTS
    node.
  ahci_xgene: Skip the PHY and clock initialization if already
    configured by the firmware.

 arch/arm64/boot/dts/apm-storm.dtsi |  5 +----
 drivers/ata/ahci_xgene.c           | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 6 deletions(-)

--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
