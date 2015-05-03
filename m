From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v3 0/2] ata: ahci_xgene: Add support for 2nd HW version of APM X-Gene SoC AHCI SATA Host controller driver.
Date: Sun,  3 May 2015 21:03:38 +0530
Message-ID: <1430667220-23477-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

V2 change:
 * Drop the MIDR based implementation.

V3 change:
 * Implement the support for HOST_IRQ_STAT as edge trigger latch.

Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---

Suman Tripathi (2):
  libahci: Add support to handle HOST_IRQ_STAT as edge trigger latch.
  ata: ahci_xgene: Add AHCI Support for 2nd HW version of APM X-Gene SoC
    AHCI SATA     Host controller.

 drivers/ata/ahci.h       |  2 ++
 drivers/ata/ahci_xgene.c | 90 ++++++++++++++++++++++++++++++++++++++----------
 drivers/ata/libahci.c    | 19 ++++++++++
 3 files changed, 93 insertions(+), 18 deletions(-)

--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
